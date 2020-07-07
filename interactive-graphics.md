# 交互式图形 {#Interactive-Graphics}

[htmlwidgets](http://www.htmlwidgets.org/) 将基于 JavaScript 的图形渲染库引入 R， [svgViewR](https://github.com/aaronolsen/svgViewR) 包制作基于 SVG 和 WebGL 的 3D 动画

Vega and Vega-Lite [vegawidget](https://github.com/vegawidget/vegawidget)
R ggplot2 "bindings" for Vega-Lite [vegalite](https://github.com/hrbrmstr/vegalite)

rgl 基于 opengl 的交互式三维图形可视化工具包

## rgl


```r
# demo('ChinaHeart3D', package = 'fun', ask = FALSE, echo = FALSE)
xtheta = function(x, theta, y, w = 0, tt = 0) {
    (x^2 + (x * tan(theta))^2 + 2 * y^2 + 0.1 * cos(w * tt) -
     0.9)^3 - (x^2 + y^2/9) * (x * tan(theta))^3
}
fz = function(z, x, y, w = 0, tt = 0) {
    (x^2 + 2 * y^2 + z^2 + 0.1 * cos(w * tt) - 0.9)^3 - (x^2 + y^2/9) * z^3
}
n = 100
y = seq(-2, 2, length.out = n)
y0 = xx = zz = NULL
for (i in 1:length(y)) {
    theta = seq(-pi/2, 1.5 * pi, length.out = n)
    solvex = function(theta, y) {
        if (theta == -pi/2 | theta == pi/2 | theta == 1.5 * pi) {
            return(0)
        } else if (theta > -pi/2 & theta < pi/2) {
            interval = c(0, 2)
        } else {
            interval = c(-2, 0)
        }
        x.root = uniroot(xtheta, interval, theta, y)$root
        return(x.root)
    }
    if (xtheta(0, pi/4, y[i]) * xtheta(2, pi/4, y[i]) > 0)
        next
    y0 = c(y0, y[i])
    x = sapply(theta, solvex, y[i])
    zplus = uniroot(fz, c(0, 2), 0, y[i])$root
    zminus = uniroot(fz, c(-2, 0), 0, y[i])$root
    z = numeric(n)
    z[x != 0] = x[x != 0] * tan(theta[x != 0])
    z[x == 0] = (theta[x == 0] == pi/2) * zplus + (theta[x == 0] != pi/2) * zminus
    xx = cbind(xx, x)
    zz = cbind(zz, z)
}
yy = matrix(rep(y0, n), n, length(y0), byrow = TRUE)
library(rgl)
persp3d(zz, xx, yy, col = "red", xlim = c(-1.2, 1.2), ylim = c(-1.2, 1.2), zlim = c(-1, 1),
        axes = FALSE, box = FALSE, xlab = "", ylab = "", zlab = "")
fy = function(y, pars) {
    z = pars[1]
    x = pars[2]
    w = pars[3]
    tt = pars[4]
    (x^2 + 2 * y^2 + z^2 + 0.1 * cos(w * tt) - 0.9)^3 - (x^2 + y^2/9) * z^3
}
gety = function(z, x, interval = c(0.01, 1), w = 0, tt = 0) {
    mpars = cbind(z, x, w, tt)
    solvey = function(pars) {
        if (fy(interval[1], pars) * fy(interval[2], pars) > 0) {
            return(NA)
        } else {
            y = uniroot(fy, interval, pars)$root
        }
    }
    y = apply(mpars, 1, solvey)
    return(y)
}
x0 = z0 = seq(-1, 1, length.out = n)
y0 = outer(z0, x0, gety)
persp3d(x = z0, y = x0, z = y0, zlim = c(-1, 1), col = "white",
        texture = system.file("img", "flag.png", package = "fun"), add = TRUE)
#> Warning in normalizePath(texture): path[1]="": No such file or directory
persp3d(x = z0, y = x0, z = -y0, zlim = c(-1, 1), col = "red", add = TRUE)
```


## leaflet {#leaflet}

leaflet 基于 leaflet.js 展示空间数据


```r
library(leaflet)
# a map with the default OSM tile layer
leaflet() %>% 
  addTiles() %>% 
  setView(-93.65, 42.0285, zoom = 17) %>% 
  addPopups(-93.65, 42.0285, 'Here is the <b>Department of Statistics</b>, ISU')
```

<!--html_preserve--><div id="htmlwidget-0eb6828b6c1154486afe" style="width:70%;height:415.296px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-0eb6828b6c1154486afe">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addPopups","args":[42.0285,-93.65,"Here is the <b>Department of Statistics<\/b>, ISU",null,null,{"maxWidth":300,"minWidth":50,"autoPan":true,"keepInView":false,"closeButton":true,"className":""}]}],"setView":[[42.0285,-93.65],17,[]],"limits":{"lat":[42.0285,42.0285],"lng":[-93.65,-93.65]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


## vegawidget

动态交互图形包 vegawidget 基于 vega 支持导出 SVG 格式图片


```r
library("vegawidget")
spec_mtcars <-
  list(
    `$schema` = vega_schema(), # specifies Vega-Lite
    description = "An mtcars example.",
    data = list(values = mtcars),
    mark = "point",
    encoding = list(
      x = list(field = "wt", type = "quantitative"),
      y = list(field = "mpg", type = "quantitative"),
      color = list(field = "cyl", type = "nominal")
    )
  ) %>% 
  as_vegaspec()
spec_mtcars
```




## 网络图 {#network}

[visNetwork](https://github.com/datastorm-open/visNetwork) 基于 vis.js 库


```r
library(visNetwork)
nodes <- data.frame(id = 1:7, label = 1:7)
edges <- data.frame(
  from = c(1, 2, 2, 2, 3, 3, 2),
  to = c(2, 3, 4, 5, 6, 7, 7)
)
```

从上到下的方向


```r
visNetwork(nodes, edges, width = "100%") %>%
  visEdges(arrows = "from") %>%
  visHierarchicalLayout() # same as visLayout(hierarchical = TRUE)
```

<!--html_preserve--><div id="htmlwidget-9580c84d0c32f0a22a8c" style="width:100%;height:415.296px;" class="visNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-9580c84d0c32f0a22a8c">{"x":{"nodes":{"id":[1,2,3,4,5,6,7],"label":[1,2,3,4,5,6,7]},"edges":{"from":[1,2,2,2,3,3,2],"to":[2,3,4,5,6,7,7]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot"},"manipulation":{"enabled":false},"edges":{"arrows":"from"},"layout":{"hierarchical":{"enabled":true}}},"groups":null,"width":"100%","height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

从左到右的方向


```r
visNetwork(nodes, edges, width = "100%") %>%
  visEdges(arrows = "to") %>%
  visHierarchicalLayout(direction = "LR", levelSeparation = 500)
```

<!--html_preserve--><div id="htmlwidget-30d3a97e9514ca5bbcd5" style="width:100%;height:415.296px;" class="visNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-30d3a97e9514ca5bbcd5">{"x":{"nodes":{"id":[1,2,3,4,5,6,7],"label":[1,2,3,4,5,6,7]},"edges":{"from":[1,2,2,2,3,3,2],"to":[2,3,4,5,6,7,7]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot"},"manipulation":{"enabled":false},"edges":{"arrows":"to"},"layout":{"hierarchical":{"enabled":true,"levelSeparation":500,"direction":"LR"}}},"groups":null,"width":"100%","height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


[DiagrammeR](https://github.com/rich-iannone/DiagrammeR) 优点是可以将网络图导出 SVG 格式


## threejs 

三维交互可视化库，比如交互式全球可视化 Building an Interactive Globe Visualization in R [threejs](https://www.displayr.com/interactive-globe-r/)
