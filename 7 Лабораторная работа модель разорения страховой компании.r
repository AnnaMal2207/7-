#7 Лабораторная работа: модель разорения страховой компании
library(VGAM)
library(ggplot2)
#1. Реализовать 1000 случайных величин 𝑁𝑡 при фиксированном значении𝑡 = 50, 𝜆 = 2;
set.seed(123)
t = 50
lamda = 2
N = 1000
Nt = rpois(N, lamda*t)
Nt
range(Nt)

#2. Построение гистограммы реализованной последовательности и наложение на гистограмму графика (13):
# y = ..density.. : функция для вычисления плотности,
f = function(x,lambda,t) { res = (lamda*t)^x/factorial(x)*exp(-lamda*t)
                           return(res)}
ggplot(data.frame(Nt), aes(x = Nt)) +
       geom_histogram(aes(y = ..density..), binwidth = 2, color = "black", fill = "white") +
       labs(title = "Гистограмма_1 Nt", x = "Nt", y = "Density") +
       theme_minimal()

hist(Nt,  main = "Гистограмма Nt", col = "grey", freq = FALSE)
grid()
hist(Nt,  main = "Гистограмма Nt", prob = TRUE, add = TRUE, col = "grey",freq = FALSE)
curve(f(x,lambda,t), add=TRUE, col = "red",xlim=c(min(Nt),max(Nt)), lwd=2, lty=2)

#3. Реализовать процесс (12) до фиксированного момента времени 𝑡𝑚𝑎𝑥 ипостроить его график.
#Предполагаем, что страховые выплаты 𝑋𝑖 распределены по экспоненциальному закону с параметром равным 1/𝜇:
mu = 3
U_0 = 50
t_max = 1000
rho = (U_0 + lamda*mu)/(mu*lamda) - 1
if (rho > 0) {T = c(0)
              U = c(U_0)
              Nt = 0
  while (sum(diff(T)) < t_max) {tau = rexp(1, lamda)
                                xi = rexp(1, mu)
                                Nt = Nt + 1
                                T[Nt+1] = T[Nt] + tau
                                U[Nt+1] = U[Nt] + tau - xi
                               }
  plot(T, U, type = "l", xlab = "Time", ylab = "U")
} else {cat("Условие (15) не выполняется")}

#4 Рассчитать выборочную вероятность разорения фирмы. Проверить выполнимость условия (16):
A = rep(0, N)
for (i in 1:N) {T = c(0)
                U = c(U_0)
                Nt = 0
                while (sum(diff(T)) < t_max) {tau = rexp(1, lamda)
                                              xi = rexp(1, mu)
                                              Nt = Nt + 1
                                              T[Nt+1] = T[Nt] + tau
                                              U[Nt+1] = U[Nt] + tau - xi
                                              if (U[Nt+1] < 0) {A[i] = 1
                                                                break}
                                             }
                }
psi_hat = mean(A)
if (rho > 0) {psi = exp(-rho*U_0/(1+rho))
              cat("Вероятность разорения:", psi_hat, "\n")
              cat("Теоретическая вероятность разорения:", psi, "\n")
              } else {cat("Условие (15) не выполняется.")}
