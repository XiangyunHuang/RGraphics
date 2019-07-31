
# 交互式图形 {#interactive-graphics}

## plotly

```r
library(plotly)
p1 <- plot_ly(diamonds, x = ~price) %>% add_histogram(name = "plotly.js")

price_hist <- function(method = "FD") {
  h <- hist(diamonds$price, breaks = method, plot = FALSE)
  plot_ly(x = h$mids, y = h$counts) %>% add_bars(name = method)
}

p <- subplot(
  p1, price_hist(), price_hist("Sturges"),  price_hist("Scott"),
  nrows = 4, shareX = TRUE
)
```

保存图片

```r
orca(p = p,file = "bars-numeric.svg")
orca(p = p, file = "bars-numeric.pdf")
```

\begin{figure}[!htb]

{\centering \includegraphics[width=0.7\linewidth,]{interactives/bars-numeric} 

}

\caption{(ref:bars-numeric)}(\#fig:bars-numeric)
\end{figure}

(ref:bars-numeric) 直方图
