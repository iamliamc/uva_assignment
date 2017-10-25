fr <- c(10000, 5000, 3333, 2500, 2000, 1667, 1428, 1250, 1111, 1000, 909)
rank <- 1:length(fr)

log_fr <- log(fr)
log_rank <- log(rank)

plot(log(fr) ~ log(rank))
reg <- lm(log(fr) ~ log(rank))
abline(reg, untf=F)
reg
summary(reg)