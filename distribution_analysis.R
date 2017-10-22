# drawn from: https://stats.stackexchange.com/questions/6780/how-to-calculate-zipfs-law-coefficient-from-a-set-of-top-frequencies
require(stats4)
#store frequencies
fr <- c(26486, 12053, 5052, 3033, 2536, 2391, 1444, 1220, 1152, 1039)

#turn frequencies into probabilities        
p <- fr/sum(fr)

#calculate the
lzipf <- function(s,N) -s*log(1:N)-log(sum(1/(1:N)^s))

opt.f <- function(s) sum((log(p)-lzipf(s, length(p)))^2)

opt <- optimize(opt.f,c(0.5, 10))
ll <- function(s) sum(fr*(s*log(1:length(p))+log(sum(1/(1:length(p))^s))))

fit <- mle(ll, start=list(s=1))
summary(fit)

s.sq <-opt$minimum
s.ll <- coef(fit)
plot(1:length(p),p,log="xy")
lines(1:length(p),exp(lzipf(s.sq,length(p))),col=2)
lines(1:length(p),exp(lzipf(s.ll,length(p))),col=3)

