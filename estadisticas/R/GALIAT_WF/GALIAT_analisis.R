# =============================================================================
# SCRIPT R — ANÁLISIS ENSAYO CLÍNICO GALIAT
# Imputación Múltiple (m=10) · Regresiones Jerárquicas por familia
# =============================================================================
# Versión : 4.0  |  Fecha: 2026-04-02
# Todos los ficheros de salida se sobreescriben en cada ejecución.
# =============================================================================

# =============================================================================
# SECCIÓN 0 · CARPETA DE TRABAJO
# Todos los ficheros generados se guardarán aquí.
# =============================================================================
dir_trabajo <- "C:/Users/alfon/Claude IA/Visual_Claude Code/R scrips/WF_GALIAT"
if (!dir.exists(dir_trabajo)) dir.create(dir_trabajo, recursive = TRUE)
setwd(dir_trabajo)
message("Carpeta de trabajo: ", getwd())

# =============================================================================
# SECCIÓN 1 · LIBRERÍAS
# =============================================================================
paquetes <- c(
  "haven",        # read_dta()
  "dplyr",        # manipulación de datos
  "moments",      # skewness(), kurtosis()
  "nortest",      # lillie.test(), ad.test()
  "outliers",     # grubbs.test()
  "mice",         # imputación múltiple
  "lme4",         # lmer() — modelos mixtos continuos
  "lmerTest",     # p-valores Satterthwaite en lmer
  "ordinal",      # clmm() — modelo mixto ordinal
  "performance",  # icc()
  "openxlsx",     # exportar Excel (overwrite=TRUE)
  "ggplot2",      # gráficos
  "patchwork",    # combinar gráficos
  "scales"        # percent_format()
)
nuevos <- paquetes[!(paquetes %in% installed.packages()[, "Package"])]
if (length(nuevos)) install.packages(nuevos, dependencies = TRUE)
invisible(lapply(paquetes, library, character.only = TRUE))
message("Librerías cargadas.")

# =============================================================================
# SECCIÓN 2 · IMPORTAR BASE DE DATOS STATA
# =============================================================================
ruta_dta <- "C:/Users/alfon/OneDrive/Datos GALIAT/GALIAT STATA/stata_galiat_hhidrica/galiat_status_diabetes_hhidrica.dta"
datos_raw <- haven::read_dta(ruta_dta)
message("Importados: ", nrow(datos_raw), " filas x ", ncol(datos_raw), " columnas.")

# =============================================================================
# SECCIÓN 3 · RECODIFICACIÓN DE ETIQUETAS STATA → R
# =============================================================================
datos <- datos_raw %>%
  mutate(across(where(haven::is.labelled), haven::as_factor))

for (v in c("grupo", "sexo", "edad")) {
  if (v %in% names(datos))
    datos[[v]] <- as.numeric(as.character(datos[[v]]))
}

if ("DMNID_pre" %in% names(datos) && is.factor(datos$DMNID_pre))
  datos$DMNID_pre <- as.numeric(as.character(datos$DMNID_pre))
if (!"DMNID_pre" %in% names(datos)) {
  message("AVISO: DMNID_pre no encontrada; se asume 0.")
  datos$DMNID_pre <- 0L
}

if (!"familia" %in% names(datos)) {
  message("AVISO: 'familia' no encontrada; se usará ID de fila.")
  datos$familia <- as.character(seq_len(nrow(datos)))
} else {
  datos$familia <- as.character(datos$familia)
}

# Etiquetas de sexo (0=Mujer, 1=Varón) y grupo (0=Control, 1=Intervención)
lbl_sex <- function(s)
  switch(as.character(s), "0" = "Mujer", "1" = "Varon", paste0("Sexo_", s))
lbl_grp <- function(g)
  switch(as.character(g), "0" = "Control", "1" = "Intervencion", paste0("Grupo_", g))

sexos_u  <- sort(unique(na.omit(datos$sexo)))
grupos_u <- sort(unique(na.omit(datos$grupo)))
cat("\nGrupos:", grupos_u, "| Sexos:", sexos_u, "\n")

# =============================================================================
# SECCIÓN 4 · OUTLIERS
# Variables: col_1, col_3, wf_1, wf_3, c_total_1, c_total_3,
#            hba1c_1, hba1c_3, glu_1, glu_3
# Métodos: rango IQR (Tukey) + test de Grubbs
# =============================================================================
vars_ppal <- intersect(
  c("col_1","col_3","wf_1","wf_3","c_total_1","c_total_3",
    "hba1c_1","hba1c_3","glu_1","glu_3"),
  names(datos)
)

cat("\n========== OUTLIERS ==========\n")
tbl_out <- do.call(base::rbind, lapply(vars_ppal, function(v) {
  x   <- na.omit(as.numeric(datos[[v]]))
  Q1  <- quantile(x, .25); Q3 <- quantile(x, .75); IQR_v <- IQR(x)
  li  <- Q1 - 1.5 * IQR_v; ls <- Q3 + 1.5 * IQR_v
  n_o <- sum(x < li | x > ls)
  gb  <- tryCatch(grubbs.test(x),
                  error = function(e) list(statistic = c(G = NA), p.value = NA))
  cat(sprintf("[%s] n=%d | IQR-outliers=%d | Grubbs G=%.4f p=%.4f\n",
              v, length(x), n_o, gb$statistic["G"], gb$p.value))
  data.frame(
    Variable = v, n = length(x),
    Q1 = round(Q1, 3), Q3 = round(Q3, 3), IQR = round(IQR_v, 3),
    Lim_inf = round(li, 3), Lim_sup = round(ls, 3),
    N_outliers_IQR = n_o,
    Grubbs_G = round(gb$statistic["G"], 4),
    Grubbs_p = round(gb$p.value, 4),
    stringsAsFactors = FALSE, row.names = NULL
  )
}))

pdf("GALIAT_boxplots_outliers.pdf", width = 14, height = 8)
par(mfrow = c(2, 5), mar = c(4, 4, 3, 1))
for (v in vars_ppal)
  boxplot(as.numeric(datos[[v]]), main = v,
          col = "#AED6F1", border = "#1A5276", outline = TRUE)
dev.off()
message("GALIAT_boxplots_outliers.pdf guardado.")

# =============================================================================
# SECCIÓN 5 · NORMALIDAD  (OUTPUT 10)
# Tests: Shapiro-Wilk, Lilliefors, Anderson-Darling + asimetría y curtosis
# Gráficos: Q-Q plots + histogramas con curva normal superpuesta
# =============================================================================
cat("\n========== NORMALIDAD ==========\n")
tbl_norm <- do.call(base::rbind, lapply(vars_ppal, function(v) {
  x  <- na.omit(as.numeric(datos[[v]])); n <- length(x)
  sw <- if (n >= 3 && n <= 5000) shapiro.test(x)
        else list(statistic = NA, p.value = NA)
  ll <- tryCatch(lillie.test(x),
                 error = function(e) list(statistic = NA, p.value = NA))
  ad <- tryCatch(ad.test(x),
                 error = function(e) list(statistic = NA, p.value = NA))
  sk <- moments::skewness(x); ku <- moments::kurtosis(x)
  cat(sprintf("[%s] n=%d | SW p=%.4f | Lillie p=%.4f | AD p=%.4f | Skew=%.3f | Kurt=%.3f\n",
              v, n, sw$p.value, ll$p.value, ad$p.value, sk, ku))
  data.frame(
    Variable = v, n = n,
    SW_W = round(sw$statistic, 5), SW_p = round(sw$p.value, 4),
    Lilliefors_p = round(ll$p.value, 4),
    AD_p = round(ad$p.value, 4),
    Skewness = round(sk, 3), Kurtosis = round(ku, 3),
    stringsAsFactors = FALSE, row.names = NULL
  )
}))

# Q-Q plots (OUTPUT 10)
pdf("GALIAT_qqplots.pdf", width = 14, height = 6)
par(mfrow = c(2, 5), mar = c(4, 4, 3, 1))
for (v in vars_ppal) {
  x <- na.omit(as.numeric(datos[[v]]))
  qqnorm(x, main = paste("Q-Q:", v), col = "#2E86C1", pch = 16, cex = .7)
  qqline(x, col = "#E74C3C", lwd = 2)
}
dev.off()

# Histogramas con curva normal (OUTPUT 10)
hists <- lapply(vars_ppal, function(v) {
  x <- na.omit(as.numeric(datos[[v]]))
  ggplot(data.frame(x = x), aes(x)) +
    geom_histogram(aes(y = after_stat(density)), bins = 20,
                   fill = "#AED6F1", color = "white", alpha = .85) +
    geom_density(color = "#E74C3C", linewidth = .9) +
    stat_function(fun = dnorm,
                  args = list(mean = mean(x), sd = sd(x)),
                  color = "#1E8449", linewidth = .9, linetype = "dashed") +
    labs(title = v, x = v, y = "Densidad") +
    theme_minimal(base_size = 10)
})
pdf("GALIAT_histogramas.pdf", width = 14, height = 6)
print(patchwork::wrap_plots(hists, ncol = 5))
dev.off()
message("Gráficas de normalidad guardadas: GALIAT_qqplots.pdf, GALIAT_histogramas.pdf")

# =============================================================================
# SECCIÓN 6 · IMPUTACIÓN MÚLTIPLE  m = 10
# =============================================================================
cat("\n========== IMPUTACIÓN MÚLTIPLE m=10 ==========\n")

vars_imputar <- c(
  "peso_1","bmi_1","indcincad_1","grascorsiri_1","lnlep_1",
  "col_1","ldl_1","lnhdl_1","lntrig_1","glu_1","hba1c_1",
  "lninsul_rep1","lnhoma_1","lnpcr_1","lntnf_1","lnil6_1",
  "pesozsc_1","pas_1","pad_1","ipq_1",
  "peso_3","bmi_3","indcincad_3","grascorsiri_3","lnlep_3",
  "col_3","ldl_3","lnhdl_3","lntrig_3","glu_3","hba1c_3",
  "lninsul_3","lnhoma_3","lnpcr_3","lntnf_3","lnil6_3",
  "pas_3","pad_3","ipq_3",
  "bmiagrup_1","bmiagrup_3","pesozsc_3",
  "circintura_1","circintura_3","carbon_1","carbon_3",
  "wf_1","wf_3","c_total_1","c_total_3"
)
vars_pred_fijos <- c("sexo", "edad", "grupo")

vars_imp_ok  <- intersect(vars_imputar,    names(datos))
vars_pred_ok <- intersect(vars_pred_fijos, names(datos))
datos_mice   <- datos[, unique(c(vars_imp_ok, vars_pred_ok))]

for (v in vars_imp_ok) {
  if (is.factor(datos_mice[[v]]) && !is.ordered(datos_mice[[v]]))
    datos_mice[[v]] <- as.numeric(as.character(datos_mice[[v]]))
}

cat("Missing antes de imputar:\n")
miss0 <- sort(sapply(datos_mice, function(x) sum(is.na(x))), decreasing = TRUE)
print(miss0[miss0 > 0])

ini     <- mice(datos_mice, maxit = 0, print = FALSE)
meth    <- ini$method
predmat <- ini$predictorMatrix

for (v in vars_pred_ok) {
  predmat[, v] <- 1
  predmat[v, ] <- 0
  meth[v]      <- ""
}

set.seed(2024)
imp <- mice(datos_mice, m = 10, maxit = 20,
            method = meth, predictorMatrix = predmat,
            print = FALSE, seed = 2024)

saveRDS(imp, "GALIAT_imp.rds")
message("Imputación completada · GALIAT_imp.rds guardado.")

pdf("GALIAT_imp_convergencia.pdf", width = 14, height = 10)
plot(imp)
dev.off()

# =============================================================================
# SECCIÓN 7 · VARIABLES DERIVADAS (post-imputación + datos originales)
# =============================================================================
generar_derivadas <- function(df) {
  if (!"DMNID_pre" %in% names(df)) df$DMNID_pre <- 0L
  for (vv in c("hba1c_1","hba1c_3","glu_1","glu_3","edad","DMNID_pre"))
    if (vv %in% names(df) && is.factor(df[[vv]]))
      df[[vv]] <- as.numeric(as.character(df[[vv]]))

  df$dia_hba1c_1 <- NA_real_
  df$dia_hba1c_1[df$hba1c_1 <  5.7 & df$edad >= 18 & df$DMNID_pre == 0] <- 0
  df$dia_hba1c_1[df$hba1c_1 >= 5.7 & df$hba1c_1 <= 6.4 &
                   df$edad >= 18 & df$DMNID_pre == 0] <- 1
  df$dia_hba1c_1[(df$hba1c_1 > 6.4 & df$edad >= 18) |
                   (df$DMNID_pre == 1 & df$edad >= 18)] <- 2

  df$dia_hba1c_3 <- NA_real_
  df$dia_hba1c_3[df$hba1c_3 <  5.7 & df$edad >= 18 & df$DMNID_pre == 0] <- 0
  df$dia_hba1c_3[df$hba1c_3 >= 5.7 & df$hba1c_3 <= 6.4 &
                   df$edad >= 18 & df$DMNID_pre == 0] <- 1
  df$dia_hba1c_3[(df$hba1c_3 > 6.4 & df$edad >= 18) |
                   (df$DMNID_pre == 1 & df$edad >= 18)] <- 2

  df$dia_glu_1 <- NA_real_
  df$dia_glu_1[df$glu_1 <  100 & df$edad >= 18 & df$DMNID_pre == 0] <- 0
  df$dia_glu_1[df$glu_1 >= 100 & df$glu_1 <= 125 &
                 df$edad >= 18 & df$DMNID_pre == 0] <- 1
  df$dia_glu_1[(df$glu_1 > 125 & df$edad >= 18) |
                 (df$DMNID_pre == 1 & df$edad >= 18)] <- 2

  df$dia_glu_3 <- NA_real_
  df$dia_glu_3[df$glu_3 <  100 & df$edad >= 18 & df$DMNID_pre == 0] <- 0
  df$dia_glu_3[df$glu_3 >= 100 & df$glu_3 <= 125 &
                 df$edad >= 18 & df$DMNID_pre == 0] <- 1
  df$dia_glu_3[(df$glu_3 > 125 & df$edad >= 18) |
                 (df$DMNID_pre == 1 & df$edad >= 18)] <- 2

  df$dia_ada_1 <- NA_real_
  ok <- !is.na(df$dia_hba1c_1) & !is.na(df$dia_glu_1)
  df$dia_ada_1[ok & df$dia_hba1c_1 == 0 & df$dia_glu_1 == 0] <- 0
  df$dia_ada_1[ok & (df$dia_hba1c_1 == 1 | df$dia_glu_1 == 1)] <- 1
  df$dia_ada_1[ok & (df$dia_hba1c_1 == 2 | df$dia_glu_1 == 2)] <- 2

  df$dia_ada_3 <- NA_real_
  ok <- !is.na(df$dia_hba1c_3) & !is.na(df$dia_glu_3)
  df$dia_ada_3[ok & df$dia_hba1c_3 == 0 & df$dia_glu_3 == 0] <- 0
  df$dia_ada_3[ok & (df$dia_hba1c_3 == 1 | df$dia_glu_3 == 1)] <- 1
  df$dia_ada_3[ok & (df$dia_hba1c_3 == 2 | df$dia_glu_3 == 2)] <- 2

  df
}

datos     <- generar_derivadas(datos)
imp_long  <- complete(imp, action = "long", include = TRUE)
aux_orig  <- datos %>%
  mutate(.id = seq_len(nrow(.))) %>%
  select(.id, DMNID_pre, familia)
imp_long  <- imp_long %>% left_join(aux_orig, by = ".id")
imp_long  <- generar_derivadas(imp_long)
imp_final <- as.mids(imp_long)
message("Variables derivadas generadas en los 10 datasets imputados.")

# =============================================================================
# SECCIÓN 8 · TABLA DESCRIPTIVA  (OUTPUT 11)
# Variables: col_1, col_3, wf_1, wf_3, c_total_1, c_total_3,
#            hba1c_1, hba1c_3, glu_1, glu_3
# Tabla A: por grupo (+total)
# Tabla B: por sexo × grupo  (sexo primero: Mujer → grupos; Varón → grupos)
# =============================================================================
vars_desc <- intersect(
  c("col_1","col_3","wf_1","wf_3","c_total_1","c_total_3",
    "hba1c_1","hba1c_3","glu_1","glu_3"),
  names(datos)
)

stat_vec <- function(x_raw, etiq_var, e1, e2) {
  x     <- as.numeric(x_raw)
  n_val <- sum(!is.na(x)); n_mis <- sum(is.na(x))
  if (n_val == 0)
    return(data.frame(Variable = etiq_var, Estrato1 = e1, Estrato2 = e2,
                      n = 0, Media = NA, DE = NA, Mediana = NA,
                      Q25 = NA, Q75 = NA, Min = NA, Max = NA,
                      IC95_inf = NA, IC95_sup = NA, Perdidos = n_mis,
                      stringsAsFactors = FALSE))
  xo <- na.omit(x); se <- sd(xo) / sqrt(n_val)
  data.frame(
    Variable = etiq_var, Estrato1 = e1, Estrato2 = e2,
    n        = n_val,
    Media    = round(mean(xo), 3),   DE      = round(sd(xo), 3),
    Mediana  = round(median(xo), 3),
    Q25      = round(quantile(xo, .25), 3),
    Q75      = round(quantile(xo, .75), 3),
    Min      = round(min(xo), 3),    Max     = round(max(xo), 3),
    IC95_inf = round(mean(xo) - qt(.975, n_val - 1) * se, 3),
    IC95_sup = round(mean(xo) + qt(.975, n_val - 1) * se, 3),
    Perdidos = n_mis, stringsAsFactors = FALSE
  )
}

# Tabla A
tbl_A <- list()
for (v in vars_desc) {
  for (g in grupos_u) {
    sub <- datos %>% filter(grupo == g)
    if (nrow(sub) > 0)
      tbl_A[[length(tbl_A) + 1]] <- stat_vec(sub[[v]], v, "Grupo", lbl_grp(g))
  }
  tbl_A[[length(tbl_A) + 1]] <- stat_vec(datos[[v]], v, "Grupo", "Total")
}
tbl_A_df <- do.call(base::rbind, tbl_A)
names(tbl_A_df)[2:3] <- c("Estrato", "Grupo")

# Tabla B
tbl_B <- list()
for (v in vars_desc) {
  for (s in sexos_u) {
    lbl_s <- lbl_sex(s)
    sub_s <- datos %>% filter(sexo == s)
    if (nrow(sub_s) > 0)
      tbl_B[[length(tbl_B) + 1]] <- stat_vec(sub_s[[v]], v, lbl_s, "Total_sexo")
    for (g in grupos_u) {
      sub_sg <- datos %>% filter(sexo == s, grupo == g)
      if (nrow(sub_sg) > 0)
        tbl_B[[length(tbl_B) + 1]] <- stat_vec(sub_sg[[v]], v, lbl_s, lbl_grp(g))
    }
  }
  tbl_B[[length(tbl_B) + 1]] <- stat_vec(datos[[v]], v, "Total", "Total")
}
tbl_B_df <- do.call(base::rbind, tbl_B)
names(tbl_B_df)[2:3] <- c("Sexo", "Grupo")

# Estilo Excel
est_cab <- createStyle(fontColour = "#FFFFFF", fgFill = "#1A5276",
                       halign = "CENTER", textDecoration = "Bold")
est_par <- createStyle(fgFill = "#D6EAF8")
est_cab2 <- createStyle(fontColour = "#FFFFFF", fgFill = "#154360",
                        halign = "CENTER", textDecoration = "Bold")
est_dep  <- createStyle(fgFill = "#FDEBD0", textDecoration = "Bold")

add_hoja <- function(wb, nombre, df, cab = est_cab) {
  addWorksheet(wb, nombre)
  if (is.null(df) || nrow(df) == 0) {
    writeData(wb, nombre, data.frame(Nota = "Sin datos")); return()
  }
  writeData(wb, nombre, df)
  addStyle(wb, nombre, cab, rows = 1,
           cols = seq_len(ncol(df)), gridExpand = TRUE)
  if (nrow(df) >= 2) {
    pares <- seq(3, nrow(df) + 1, by = 2)
    addStyle(wb, nombre, est_par, rows = pares,
             cols = seq_len(ncol(df)), gridExpand = TRUE)
  }
  setColWidths(wb, nombre, cols = seq_len(ncol(df)), widths = "auto")
}

add_reg_hoja <- function(wb, nombre, df) {
  addWorksheet(wb, nombre)
  if (is.null(df) || nrow(df) == 0) {
    writeData(wb, nombre, data.frame(Nota = "Sin resultados"))
    return(invisible(NULL))
  }
  writeData(wb, nombre, df)
  addStyle(wb, nombre, est_cab2, rows = 1,
           cols = seq_len(ncol(df)), gridExpand = TRUE)
  cambios <- which(!duplicated(df$Variable_dep)) + 1
  if (length(cambios))
    addStyle(wb, nombre, est_dep, rows = cambios,
             cols = seq_len(ncol(df)), gridExpand = TRUE)
  invisible(setColWidths(wb, nombre, cols = seq_len(ncol(df)), widths = "auto"))
}

wb_desc <- createWorkbook()
add_hoja(wb_desc, "Por_Grupo",      tbl_A_df)
add_hoja(wb_desc, "Por_Sexo_Grupo", tbl_B_df)
add_hoja(wb_desc, "Normalidad",     tbl_norm)
add_hoja(wb_desc, "Outliers",       tbl_out)
saveWorkbook(wb_desc, "GALIAT_descriptivos.xlsx", overwrite = TRUE)
message("GALIAT_descriptivos.xlsx guardado.")

# =============================================================================
# SECCIÓN 9 · FUNCIONES DE REGRESIÓN
# =============================================================================
ctrl_lmr <- lmerControl(optimizer = "bobyqa")

rubin_pool <- function(bmat, vmat, m) {
  Q  <- colMeans(bmat); U <- colMeans(vmat)
  B  <- apply(bmat, 2, var); T. <- U + (1 + 1/m) * B; SE <- sqrt(T.)
  list(Q = Q, SE = SE, lo = Q - 1.96*SE, hi = Q + 1.96*SE,
       p  = 2 * pnorm(-abs(Q / SE)))
}

icc_lmer_val <- function(mod) {
  if (is.null(mod)) return(NA_real_)
  tryCatch(round(performance::icc(mod)$ICC_adjusted, 4), error = function(e) NA_real_)
}

icc_clmm_val <- function(mod) {
  vc <- tryCatch(as.data.frame(VarCorr(mod)), error = function(e) NULL)
  if (is.null(vc)) return(NA_real_)
  vr <- vc$vcov[vc$grp != "Residual"][1]
  round(vr / (vr + pi^2/3), 4)
}

tbl_lmer <- function(mod, vdep, estrato, analisis, icc_v = NA) {
  if (is.null(mod)) return(NULL)
  cf  <- summary(mod)$coefficients; pnm <- rownames(cf)
  ci  <- tryCatch(
    { c2 <- confint(mod, method = "Wald")
      c2[rownames(c2) %in% pnm, , drop = FALSE] },
    error = function(e) {
      se <- cf[, "Std. Error"]; est <- cf[, "Estimate"]
      m  <- cbind(est - 1.96*se, est + 1.96*se); rownames(m) <- pnm; m
    }
  )
  pnm2 <- intersect(pnm, rownames(ci))
  data.frame(
    Analisis = analisis, Variable_dep = vdep, Estrato = estrato,
    Predictor = pnm2,
    Beta      = round(cf[pnm2, "Estimate"],   4),
    SE        = round(cf[pnm2, "Std. Error"], 4),
    t         = round(cf[pnm2, "t value"],    4),
    p         = round(cf[pnm2, "Pr(>|t|)"],   4),
    IC95_inf  = round(ci[pnm2, 1], 4),
    IC95_sup  = round(ci[pnm2, 2], 4),
    Resultado = sprintf("%.3f (%.3f; %.3f) p=%.4f",
                        cf[pnm2, "Estimate"], ci[pnm2, 1], ci[pnm2, 2],
                        cf[pnm2, "Pr(>|t|)"]),
    ICC = icc_v, stringsAsFactors = FALSE, row.names = NULL
  )
}

tbl_clmm <- function(mod, vdep, estrato, analisis, icc_v = NA) {
  if (is.null(mod)) return(NULL)
  cf  <- summary(mod)$coefficients
  pnm <- rownames(cf)[!grepl("\\|", rownames(cf))]
  cf  <- cf[pnm, , drop = FALSE]
  ci  <- tryCatch(
    confint(mod, parm = pnm),
    error = function(e) {
      se <- cf[, "Std. Error"]; est <- cf[, "Estimate"]
      m  <- cbind(est - 1.96*se, est + 1.96*se); rownames(m) <- pnm; m
    }
  )
  pnm2 <- intersect(pnm, rownames(ci))
  data.frame(
    Analisis    = analisis, Variable_dep = vdep, Estrato = estrato,
    Predictor   = pnm2,
    OR          = round(exp(cf[pnm2, "Estimate"]), 4),
    Beta        = round(cf[pnm2, "Estimate"],       4),
    SE          = round(cf[pnm2, "Std. Error"],     4),
    z           = round(cf[pnm2, "z value"],        4),
    p           = round(cf[pnm2, "Pr(>|z|)"],       4),
    IC95_inf_OR = round(exp(ci[pnm2, 1]), 4),
    IC95_sup_OR = round(exp(ci[pnm2, 2]), 4),
    Resultado   = sprintf("OR=%.3f (%.3f; %.3f) p=%.4f",
                          exp(cf[pnm2, "Estimate"]),
                          exp(ci[pnm2, 1]), exp(ci[pnm2, 2]),
                          cf[pnm2, "Pr(>|z|)"]),
    ICC = icc_v, stringsAsFactors = FALSE, row.names = NULL
  )
}

pool_lmer_tbl <- function(fmla, ldat, nm, vdep, estrato, analisis) {
  fits <- lapply(seq_len(nm), function(i) {
    di <- ldat[ldat$.imp == i, ]
    tryCatch(lmer(as.formula(fmla), data = di, REML = TRUE, control = ctrl_lmr),
             error = function(e) NULL)
  })
  fits <- Filter(Negate(is.null), fits); if (!length(fits)) return(NULL)
  bmat  <- do.call(base::rbind, lapply(fits, fixef))
  vmat  <- do.call(base::rbind, lapply(fits, function(m) diag(as.matrix(vcov(m)))))
  pl    <- rubin_pool(bmat, vmat, length(fits))
  icc_v <- round(mean(sapply(fits, icc_lmer_val), na.rm = TRUE), 4)
  data.frame(
    Analisis = analisis, Variable_dep = vdep, Estrato = estrato,
    Predictor = names(pl$Q),
    Beta = round(pl$Q, 4), SE = round(pl$SE, 4),
    t    = round(pl$Q / pl$SE, 4), p = round(pl$p, 4),
    IC95_inf = round(pl$lo, 4), IC95_sup = round(pl$hi, 4),
    Resultado = sprintf("%.3f (%.3f; %.3f) p=%.4f", pl$Q, pl$lo, pl$hi, pl$p),
    ICC = icc_v, stringsAsFactors = FALSE, row.names = NULL
  )
}

pool_clmm_tbl <- function(fmla, ldat, nm, vdep, estrato, analisis) {
  fits <- lapply(seq_len(nm), function(i) {
    di <- ldat[ldat$.imp == i, ]
    tryCatch(clmm(as.formula(fmla), data = di, link = "logit", na.action = na.omit),
             error = function(e) NULL)
  })
  fits <- Filter(Negate(is.null), fits); if (!length(fits)) return(NULL)
  pnm  <- names(fits[[1]]$beta)
  bmat <- do.call(base::rbind, lapply(fits, function(m) m$beta[pnm]))
  vmat <- do.call(base::rbind, lapply(fits, function(m) {
    vc <- as.matrix(vcov(m)); diag(vc)[pnm]
  }))
  pl    <- rubin_pool(bmat, vmat, length(fits))
  icc_v <- round(mean(sapply(fits, icc_clmm_val), na.rm = TRUE), 4)
  data.frame(
    Analisis    = analisis, Variable_dep = vdep, Estrato = estrato,
    Predictor   = names(pl$Q),
    OR          = round(exp(pl$Q), 4), Beta = round(pl$Q, 4),
    SE          = round(pl$SE, 4), z = round(pl$Q / pl$SE, 4),
    p           = round(pl$p, 4),
    IC95_inf_OR = round(exp(pl$lo), 4), IC95_sup_OR = round(exp(pl$hi), 4),
    Resultado   = sprintf("OR=%.3f (%.3f; %.3f) p=%.4f",
                          exp(pl$Q), exp(pl$lo), exp(pl$hi), pl$p),
    ICC = icc_v, stringsAsFactors = FALSE, row.names = NULL
  )
}

fit_lmer <- function(fmla, dat)
  tryCatch(lmer(as.formula(fmla), data = dat, REML = TRUE, control = ctrl_lmr),
           error = function(e) { message("  lmer: ", e$message); NULL })

fit_clmm <- function(fmla, dat)
  tryCatch(clmm(as.formula(fmla), data = dat, link = "logit", na.action = na.omit),
           error = function(e) { message("  clmm: ", e$message); NULL })

# =============================================================================
# SECCIÓN 10 · PREPARAR DATOS PARA REGRESIONES
# =============================================================================
# datos_reg = datos original con dia_ada_1/3 como factor ordenado (para clmm).
# Las variables continuas (col_1, col_3, wf_1, wf_3, c_total_1, c_total_3...)
# se usan tal como están en datos para que lmer funcione igual que si se
# ejecutara manualmente con data = datos.
datos_reg <- datos
datos_reg$dia_ada_1 <- factor(datos_reg$dia_ada_1, levels = c(0,1,2), ordered = TRUE)
datos_reg$dia_ada_3 <- factor(datos_reg$dia_ada_3, levels = c(0,1,2), ordered = TRUE)

# Diagnóstico: tipo y disponibilidad de variables para SIN imputación
cat("\nDatos originales disponibles para regresiones SIN imputación:\n")
vars_diag <- intersect(
  c("col_1","col_3","wf_1","wf_3","c_total_1","c_total_3","dia_ada_3"),
  names(datos_reg)
)
for (v in vars_diag)
  cat(sprintf("  %-14s  n_validos=%d  n_NA=%d  clase=%s\n",
              v,
              sum(!is.na(datos_reg[[v]])),
              sum(is.na(datos_reg[[v]])),
              paste(class(datos_reg[[v]]), collapse = "/")))

imp_long_mod <- complete(imp_final, action = "long", include = FALSE)
if (!"familia" %in% names(imp_long_mod))
  imp_long_mod <- imp_long_mod %>% left_join(aux_orig, by = ".id")
imp_long_mod <- imp_long_mod %>%
  mutate(
    grupo     = as.numeric(as.character(grupo)),
    sexo      = as.numeric(as.character(sexo)),
    edad      = as.numeric(as.character(edad)),
    familia   = as.character(familia),
    dia_ada_1 = factor(dia_ada_1, levels = c(0,1,2), ordered = TRUE),
    dia_ada_3 = factor(dia_ada_3, levels = c(0,1,2), ordered = TRUE)
  )
n_imp <- max(imp_long_mod$.imp)

# Definición de los 4 modelos
modelos <- list(
  list(dep = "col_3",     tipo = "lmer",
       f_tot = "col_3 ~ col_1 + edad + sexo + grupo + (1|familia)",
       f_sex = "col_3 ~ col_1 + edad + grupo + (1|familia)"),
  list(dep = "wf_3",      tipo = "lmer",
       f_tot = "wf_3 ~ wf_1 + edad + sexo + grupo + (1|familia)",
       f_sex = "wf_3 ~ wf_1 + edad + grupo + (1|familia)"),
  list(dep = "c_total_3", tipo = "lmer",
       f_tot = "c_total_3 ~ c_total_1 + edad + sexo + grupo + (1|familia)",
       f_sex = "c_total_3 ~ c_total_1 + edad + grupo + (1|familia)"),
  list(dep = "dia_ada_3", tipo = "clmm",
       f_tot = "dia_ada_3 ~ dia_ada_1 + edad + sexo + grupo + (1|familia)",
       f_sex = "dia_ada_3 ~ dia_ada_1 + edad + grupo + (1|familia)")
)

# =============================================================================
# SECCIÓN 11 · REGRESIONES SIN IMPUTACIÓN  (OUTPUT 12)
# =============================================================================
cat("\nModelos SIN imputación (punto 8)...\n")
sin_tot <- list(); sin_muj <- list(); sin_var <- list()

for (md in modelos) {
  dep <- md$dep; tipo <- md$tipo
  cat(" [", dep, "]\n")
  m     <- if (tipo == "lmer") fit_lmer(md$f_tot, datos_reg)
            else                fit_clmm(md$f_tot, datos_reg)
  icc_v <- if (tipo == "lmer") icc_lmer_val(m) else icc_clmm_val(m)
  sin_tot[[dep]] <- if (tipo == "lmer")
    tbl_lmer(m, dep, "Total", "Sin imputacion", icc_v)
  else
    tbl_clmm(m, dep, "Total", "Sin imputacion", icc_v)

  for (s in sexos_u) {
    dat_s <- datos_reg %>% filter(sexo == s)
    ms    <- if (tipo == "lmer") fit_lmer(md$f_sex, dat_s)
              else                fit_clmm(md$f_sex, dat_s)
    icc_s <- if (tipo == "lmer") icc_lmer_val(ms) else icc_clmm_val(ms)
    tbl_s <- if (tipo == "lmer") tbl_lmer(ms, dep, lbl_sex(s), "Sin imputacion", icc_s)
              else                tbl_clmm(ms, dep, lbl_sex(s), "Sin imputacion", icc_s)
    if (s == 0) sin_muj[[dep]] <- tbl_s else sin_var[[dep]] <- tbl_s
  }
}

df_sin_tot <- do.call(base::rbind, sin_tot)
df_sin_muj <- do.call(base::rbind, sin_muj)
df_sin_var <- do.call(base::rbind, sin_var)

wb_sin <- createWorkbook()
add_reg_hoja(wb_sin, "Total", df_sin_tot)
add_reg_hoja(wb_sin, "Mujer", df_sin_muj)
add_reg_hoja(wb_sin, "Varon", df_sin_var)
saveWorkbook(wb_sin, "GALIAT_regresiones_SIN_imputacion.xlsx", overwrite = TRUE)
message("GALIAT_regresiones_SIN_imputacion.xlsx guardado.")

# =============================================================================
# SECCIÓN 12 · REGRESIONES CON IMPUTACIÓN  (OUTPUT 13)
# =============================================================================
cat("\nModelos CON imputación (punto 9, Reglas de Rubin)...\n")
con_tot <- list(); con_muj <- list(); con_var <- list()

for (md in modelos) {
  dep <- md$dep; tipo <- md$tipo
  cat(" [", dep, "]\n")
  con_tot[[dep]] <- if (tipo == "lmer")
    pool_lmer_tbl(md$f_tot, imp_long_mod, n_imp, dep, "Total", "Con imputacion")
  else
    pool_clmm_tbl(md$f_tot, imp_long_mod, n_imp, dep, "Total", "Con imputacion")

  for (s in sexos_u) {
    imp_s <- imp_long_mod %>% filter(sexo == s)
    tbl_s <- if (tipo == "lmer")
      pool_lmer_tbl(md$f_sex, imp_s, n_imp, dep, lbl_sex(s), "Con imputacion")
    else
      pool_clmm_tbl(md$f_sex, imp_s, n_imp, dep, lbl_sex(s), "Con imputacion")
    if (s == 0) con_muj[[dep]] <- tbl_s else con_var[[dep]] <- tbl_s
  }
}

df_con_tot <- do.call(base::rbind, con_tot)
df_con_muj <- do.call(base::rbind, con_muj)
df_con_var <- do.call(base::rbind, con_var)

wb_con <- createWorkbook()
add_reg_hoja(wb_con, "Total", df_con_tot)
add_reg_hoja(wb_con, "Mujer", df_con_muj)
add_reg_hoja(wb_con, "Varon", df_con_var)
saveWorkbook(wb_con, "GALIAT_regresiones_CON_imputacion.xlsx", overwrite = TRUE)
message("GALIAT_regresiones_CON_imputacion.xlsx guardado.")

# =============================================================================
# SECCIÓN 13 · GRÁFICAS  (OUTPUTS 14 y 15)
# Output 14: forest plots + curvas para modelos SIN imputación (punto 8)
# Output 15: forest plots para modelos CON imputación (punto 9)
#            + panel comparativo SIN vs CON
# =============================================================================
CTRL <- "#2E86C1"; INTV <- "#E74C3C"

# ---- Forest plot genérico: continua ----
fp_cont <- function(df, vdep, titulo) {
  if (is.null(df) || nrow(df) == 0) return(NULL)
  cols_need <- c("Variable_dep","Estrato","Beta","IC95_inf","IC95_sup","p")
  if (!all(cols_need %in% names(df))) return(NULL)
  sub <- df[df$Variable_dep == vdep & df$Predictor == "grupo",
             cols_need, drop = FALSE]
  if (nrow(sub) == 0) return(NULL)
  sub$Estrato <- factor(sub$Estrato, levels = rev(unique(sub$Estrato)))
  ggplot(sub, aes(x = Beta, y = Estrato)) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "gray60") +
    geom_errorbarh(aes(xmin = IC95_inf, xmax = IC95_sup),
                   height = .25, linewidth = .8, color = CTRL) +
    geom_point(size = 3.5, color = CTRL) +
    labs(title = titulo,
         subtitle = "Efecto grupo: Intervención vs Control (β, IC 95%)",
         x = "β (IC 95%)", y = NULL) +
    theme_minimal(base_size = 12) +
    theme(plot.title    = element_text(face = "bold", hjust = .5),
          plot.subtitle = element_text(hjust = .5, color = "gray40"),
          panel.grid.minor = element_blank())
}

# ---- Forest plot genérico: ordinal ----
fp_ord <- function(df, vdep, titulo) {
  if (is.null(df) || nrow(df) == 0) return(NULL)
  cols_need <- c("Variable_dep","Estrato","OR","IC95_inf_OR","IC95_sup_OR","p")
  if (!all(cols_need %in% names(df))) return(NULL)
  sub <- df[df$Variable_dep == vdep & df$Predictor == "grupo",
             cols_need, drop = FALSE]
  if (nrow(sub) == 0) return(NULL)
  sub$Estrato <- factor(sub$Estrato, levels = rev(unique(sub$Estrato)))
  ggplot(sub, aes(x = OR, y = Estrato)) +
    geom_vline(xintercept = 1, linetype = "dashed", color = "gray60") +
    geom_errorbarh(aes(xmin = IC95_inf_OR, xmax = IC95_sup_OR),
                   height = .25, linewidth = .8, color = INTV) +
    geom_point(size = 3.5, color = INTV) +
    scale_x_log10() +
    labs(title = titulo,
         subtitle = "OR grupo: Intervención vs Control (IC 95%, escala log)",
         x = "OR (IC 95%)", y = NULL) +
    theme_minimal(base_size = 12) +
    theme(plot.title    = element_text(face = "bold", hjust = .5),
          plot.subtitle = element_text(hjust = .5, color = "gray40"),
          panel.grid.minor = element_blank())
}

# ---- Forest plot comparativo SIN vs CON ----
fp_comp_cont <- function(df, vdep, titulo) {
  if (is.null(df) || nrow(df) == 0) return(NULL)
  cols_need <- c("Analisis","Variable_dep","Estrato","Beta","IC95_inf","IC95_sup")
  if (!all(cols_need %in% names(df))) return(NULL)
  sub <- df[df$Variable_dep == vdep & df$Predictor == "grupo",
             cols_need, drop = FALSE]
  if (nrow(sub) == 0) return(NULL)
  sub$Analisis <- factor(sub$Analisis,
                         levels = c("Sin imputacion","Con imputacion"))
  sub$Estrato  <- factor(sub$Estrato, levels = rev(unique(sub$Estrato)))
  ggplot(sub, aes(x = Beta, y = Estrato, color = Analisis, shape = Analisis)) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "gray60") +
    geom_errorbarh(aes(xmin = IC95_inf, xmax = IC95_sup),
                   height = .25, linewidth = .8,
                   position = position_dodge(.5)) +
    geom_point(size = 3.5, position = position_dodge(.5)) +
    scale_color_manual(values = c("Sin imputacion" = CTRL, "Con imputacion" = INTV)) +
    scale_shape_manual(values = c("Sin imputacion" = 16, "Con imputacion" = 17)) +
    labs(title = titulo, x = "β (IC 95%)", y = NULL, color = NULL, shape = NULL) +
    theme_minimal(base_size = 12) +
    theme(plot.title = element_text(face = "bold", hjust = .5),
          legend.position = "bottom", panel.grid.minor = element_blank())
}

fp_comp_ord <- function(df, vdep, titulo) {
  if (is.null(df) || nrow(df) == 0) return(NULL)
  cols_need <- c("Analisis","Variable_dep","Estrato","OR","IC95_inf_OR","IC95_sup_OR")
  if (!all(cols_need %in% names(df))) return(NULL)
  sub <- df[df$Variable_dep == vdep & df$Predictor == "grupo",
             cols_need, drop = FALSE]
  if (nrow(sub) == 0) return(NULL)
  sub$Analisis <- factor(sub$Analisis,
                         levels = c("Sin imputacion","Con imputacion"))
  sub$Estrato  <- factor(sub$Estrato, levels = rev(unique(sub$Estrato)))
  ggplot(sub, aes(x = OR, y = Estrato, color = Analisis, shape = Analisis)) +
    geom_vline(xintercept = 1, linetype = "dashed", color = "gray60") +
    geom_errorbarh(aes(xmin = IC95_inf_OR, xmax = IC95_sup_OR),
                   height = .25, linewidth = .8,
                   position = position_dodge(.5)) +
    geom_point(size = 3.5, position = position_dodge(.5)) +
    scale_x_log10() +
    scale_color_manual(values = c("Sin imputacion" = CTRL, "Con imputacion" = INTV)) +
    scale_shape_manual(values = c("Sin imputacion" = 16, "Con imputacion" = 17)) +
    labs(title = titulo, x = "OR (IC 95%)", y = NULL, color = NULL, shape = NULL) +
    theme_minimal(base_size = 12) +
    theme(plot.title = element_text(face = "bold", hjust = .5),
          legend.position = "bottom", panel.grid.minor = element_blank())
}

# ---- Curvas predichas Control vs Intervención ----
curva_grp <- function(fmla, vbase, vdep, dat, titulo) {
  mod <- fit_lmer(fmla, dat); if (is.null(mod)) return(NULL)
  rng  <- range(dat[[vbase]], na.rm = TRUE)
  grid <- expand.grid(
    x_    = seq(rng[1], rng[2], length.out = 60),
    grupo = c(0, 1),
    edad  = mean(dat$edad, na.rm = TRUE),
    sexo  = as.numeric(names(sort(table(dat$sexo), decreasing = TRUE)[1]))
  )
  names(grid)[1] <- vbase
  grid$pred  <- predict(mod, newdata = grid, re.form = NA)
  grid$Grupo <- factor(grid$grupo, levels = c(0,1),
                       labels = c("Control", "Intervención"))
  ggplot(grid, aes(x = .data[[vbase]], y = pred, color = Grupo)) +
    geom_line(linewidth = 1.3) +
    scale_color_manual(values = c("Control" = CTRL, "Intervención" = INTV)) +
    labs(title = titulo, x = paste("Basal:", vbase),
         y = paste("Predicho:", vdep), color = "Grupo",
         caption = "Estimación marginal (edad y sexo en media/moda). Sin efecto aleatorio familia.") +
    theme_minimal(base_size = 12) +
    theme(plot.title = element_text(face = "bold", hjust = .5),
          legend.position = "bottom")
}

guardar <- function(g, f, w = 10, h = 6)
  if (!is.null(g)) { ggsave(f, g, width = w, height = h, dpi = 300)
                     message("Guardado: ", f) }

# Combinar estratos por análisis
df_sin_all <- do.call(base::rbind,
                      Filter(Negate(is.null), list(df_sin_tot, df_sin_muj, df_sin_var)))
df_con_all <- do.call(base::rbind,
                      Filter(Negate(is.null), list(df_con_tot, df_con_muj, df_con_var)))
df_comp    <- do.call(base::rbind,
                      Filter(Negate(is.null), list(df_sin_all, df_con_all)))

# ---- OUTPUT 14: gráficas SIN imputación ----
g14_col  <- fp_cont(df_sin_all, "col_3",     "Colesterol Total — SIN imputación")
g14_wf   <- fp_cont(df_sin_all, "wf_3",      "WF — SIN imputación")
g14_ctot <- fp_cont(df_sin_all, "c_total_3", "C Total — SIN imputación")
g14_ada  <- fp_ord( df_sin_all, "dia_ada_3", "Diabetes ADA — SIN imputación")

g14_c_col  <- curva_grp("col_3 ~ col_1 + edad + sexo + grupo + (1|familia)",
                         "col_1","col_3", datos_reg,
                         "Colesterol Total: Control vs Intervención (sin imp.)")
g14_c_wf   <- curva_grp("wf_3 ~ wf_1 + edad + sexo + grupo + (1|familia)",
                         "wf_1","wf_3", datos_reg,
                         "WF: Control vs Intervención (sin imp.)")
g14_c_ctot <- curva_grp("c_total_3 ~ c_total_1 + edad + sexo + grupo + (1|familia)",
                         "c_total_1","c_total_3", datos_reg,
                         "C Total: Control vs Intervención (sin imp.)")

guardar(g14_col,    "GALIAT_SIN_forest_col.png")
guardar(g14_wf,     "GALIAT_SIN_forest_wf.png")
guardar(g14_ctot,   "GALIAT_SIN_forest_ctotal.png")
guardar(g14_ada,    "GALIAT_SIN_forest_ada.png")
guardar(g14_c_col,  "GALIAT_SIN_curva_col.png")
guardar(g14_c_wf,   "GALIAT_SIN_curva_wf.png")
guardar(g14_c_ctot, "GALIAT_SIN_curva_ctotal.png")

ggs14 <- Filter(Negate(is.null), list(g14_col, g14_wf, g14_ctot, g14_ada))
if (length(ggs14)) {
  p14 <- patchwork::wrap_plots(ggs14, ncol = 2) +
    patchwork::plot_annotation(
      title = "GALIAT — Forest plots SIN Imputación (punto 8)",
      theme = theme(plot.title = element_text(face = "bold", hjust = .5, size = 14)))
  ggsave("GALIAT_SIN_panel_forest.png", p14, width = 16, height = 12, dpi = 300)
  message("GALIAT_SIN_panel_forest.png guardado.")
}
ggc14 <- Filter(Negate(is.null), list(g14_c_col, g14_c_wf, g14_c_ctot))
if (length(ggc14)) {
  pc14 <- patchwork::wrap_plots(ggc14, ncol = 2) +
    patchwork::plot_annotation(
      title = "GALIAT — Curvas predichas SIN Imputación",
      theme = theme(plot.title = element_text(face = "bold", hjust = .5, size = 14)))
  ggsave("GALIAT_SIN_panel_curvas.png", pc14, width = 16, height = 8, dpi = 300)
  message("GALIAT_SIN_panel_curvas.png guardado.")
}

# ---- OUTPUT 15: gráficas CON imputación ----
g15_col  <- fp_cont(df_con_all, "col_3",     "Colesterol Total — CON imputación")
g15_wf   <- fp_cont(df_con_all, "wf_3",      "WF — CON imputación")
g15_ctot <- fp_cont(df_con_all, "c_total_3", "C Total — CON imputación")
g15_ada  <- fp_ord( df_con_all, "dia_ada_3", "Diabetes ADA — CON imputación")

guardar(g15_col,  "GALIAT_CON_forest_col.png")
guardar(g15_wf,   "GALIAT_CON_forest_wf.png")
guardar(g15_ctot, "GALIAT_CON_forest_ctotal.png")
guardar(g15_ada,  "GALIAT_CON_forest_ada.png")

ggs15 <- Filter(Negate(is.null), list(g15_col, g15_wf, g15_ctot, g15_ada))
if (length(ggs15)) {
  p15 <- patchwork::wrap_plots(ggs15, ncol = 2) +
    patchwork::plot_annotation(
      title = "GALIAT — Forest plots CON Imputación m=10 (punto 9)",
      theme = theme(plot.title = element_text(face = "bold", hjust = .5, size = 14)))
  ggsave("GALIAT_CON_panel_forest.png", p15, width = 16, height = 12, dpi = 300)
  message("GALIAT_CON_panel_forest.png guardado.")
}

# Panel comparativo SIN vs CON
gc_col  <- fp_comp_cont(df_comp, "col_3",     "Colesterol — SIN vs CON imputación")
gc_wf   <- fp_comp_cont(df_comp, "wf_3",      "WF — SIN vs CON imputación")
gc_ctot <- fp_comp_cont(df_comp, "c_total_3", "C Total — SIN vs CON imputación")
gc_ada  <- fp_comp_ord( df_comp, "dia_ada_3", "Diabetes ADA — SIN vs CON imputación")

guardar(gc_col,  "GALIAT_COMP_col.png")
guardar(gc_wf,   "GALIAT_COMP_wf.png")
guardar(gc_ctot, "GALIAT_COMP_ctotal.png")
guardar(gc_ada,  "GALIAT_COMP_ada.png")

ggsc <- Filter(Negate(is.null), list(gc_col, gc_wf, gc_ctot, gc_ada))
if (length(ggsc)) {
  psc <- patchwork::wrap_plots(ggsc, ncol = 2) +
    patchwork::plot_annotation(
      title = "GALIAT — Comparación SIN vs CON Imputación Múltiple",
      theme = theme(plot.title = element_text(face = "bold", hjust = .5, size = 14)))
  ggsave("GALIAT_COMP_panel.png", psc, width = 16, height = 12, dpi = 300)
  message("GALIAT_COMP_panel.png guardado.")
}

# =============================================================================
# RESUMEN FINAL
# =============================================================================
cat("\n\n========== COMPLETADO ==========\n")
cat("Carpeta:", getwd(), "\n\n")
cat("GALIAT_descriptivos.xlsx              (OUTPUT 11)\n")
cat("  · Por_Grupo, Por_Sexo_Grupo, Normalidad, Outliers\n")
cat("GALIAT_regresiones_SIN_imputacion.xlsx (OUTPUT 12)\n")
cat("  · Total, Mujer, Varon\n")
cat("GALIAT_regresiones_CON_imputacion.xlsx (OUTPUT 13)\n")
cat("  · Total, Mujer, Varon\n")
cat("GALIAT_qqplots.pdf, GALIAT_histogramas.pdf  (OUTPUT 10)\n")
cat("GALIAT_boxplots_outliers.pdf\n")
cat("GALIAT_imp_convergencia.pdf\n")
cat("GALIAT_imp.rds\n")
cat("GALIAT_SIN_forest_[col|wf|ctotal|ada].png   (OUTPUT 14)\n")
cat("GALIAT_SIN_curva_[col|wf|ctotal].png         (OUTPUT 14)\n")
cat("GALIAT_SIN_panel_forest.png\n")
cat("GALIAT_SIN_panel_curvas.png\n")
cat("GALIAT_CON_forest_[col|wf|ctotal|ada].png   (OUTPUT 15)\n")
cat("GALIAT_CON_panel_forest.png\n")
cat("GALIAT_COMP_[col|wf|ctotal|ada].png         (OUTPUT 15)\n")
cat("GALIAT_COMP_panel.png\n")
cat("=================================\n")
