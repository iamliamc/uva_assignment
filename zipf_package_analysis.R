#store frequencies
require(zipfR)
freq <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 18, 19, 21, 22, 27, 28, 55, 61, 88, 89, 117, 174)
freq_occurences <- c(656, 165, 57, 25, 23, 10, 9, 7, 4, 3, 2, 2, 5, 1, 3, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1)
d <- spc(freq, freq_occurences)
z <- lnre("fzm", d, exact=FALSE)
summary(z)
