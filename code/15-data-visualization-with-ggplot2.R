## ----include=FALSE-------------------------------------------------------
library(ggplot2)
library(magrittr)


## ----awesome-ggplot2,fig.cap="简洁美观"----------------------------------
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = TRUE, method = "loess") +
  labs(
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov"
  )


## ------------------------------------------------------------------------
ls("package:ggplot2", pattern = "^geom_")


## ------------------------------------------------------------------------
ggplot(airquality, aes(x = Temp, y = Ozone)) + geom_point()


## ------------------------------------------------------------------------
ls("package:ggplot2", pattern = "^theme_")


## ------------------------------------------------------------------------
ggplot(airquality, aes(x = Temp, y = Ozone)) + geom_point() + theme_bw()
ggplot(airquality, aes(x = Temp, y = Ozone)) + geom_point() + theme_void()
ggplot(airquality, aes(x = Temp, y = Ozone)) + geom_point() + theme_minimal()
ggplot(airquality, aes(x = Temp, y = Ozone)) + geom_point() + theme_void()


## ------------------------------------------------------------------------
ls("package:ggplot2", pattern = "^scale_(color|fill)_")


## ------------------------------------------------------------------------
ggplot(airquality, aes(x = Temp, y = Ozone, color = as.factor(Month))) +
  geom_point()
ggplot(airquality, aes(x = Temp, y = Ozone, color = as.ordered(Month))) +
  geom_point()


## ------------------------------------------------------------------------
ls("package:ggplot2", pattern = "^scale_(x|y)_")


## ------------------------------------------------------------------------
range(airquality$Temp, na.rm = TRUE)
range(airquality$Ozone, na.rm = TRUE)
ggplot(airquality, aes(x = Temp, y = Ozone)) + geom_point() +
  scale_x_continuous(breaks = seq(50, 100, 5)) +
  scale_y_continuous(breaks = seq(0, 200, 20))


## ------------------------------------------------------------------------
ls("package:ggplot2", pattern = "^annotation_")


## ------------------------------------------------------------------------
ggplot(airquality, aes(x = Temp, y = Ozone)) + geom_point()


## ----math-expr-r---------------------------------------------------------
ggplot(airquality, aes(x = Temp, y = Ozone)) + geom_point() +
  labs(title = substitute(paste(d *
    bolditalic(x)[italic(t)] == alpha * (theta - bolditalic(x)[italic(t)]) *
    d * italic(t) + lambda * d * italic(B)[italic(t)]), list(lambda = 4)))


## ------------------------------------------------------------------------
ggplot(airquality) + geom_point(aes(x = Temp, y = Ozone)) + facet_wrap(~ as.ordered(Month))
ggplot(airquality) + geom_point(aes(x = Temp, y = Ozone)) + facet_wrap(~ as.ordered(Month), nrow = 1)


## ------------------------------------------------------------------------
ls("package:ggplot2", pattern = "^coord_")


## ----load-data-----------------------------------------------------------
data(diamonds)
str(diamonds)


## ----diamonds-axis,fig.cap=c("指定 x 轴","数值变量 price 作为纵轴","有序分类变量 cut 指定颜色","指定统一颜色"),out.width="35%",fig.align='center',fig.ncol=2,fig.width=3----
ggplot(diamonds, aes(x = carat))
ggplot(diamonds, aes(x = carat, y = price))
ggplot(diamonds, aes(x = carat, color = cut))
ggplot(diamonds, aes(x = carat), color = "steelblue")


## ----scatter,fig.cap="添加数据图层"--------------------------------------
sub_diamonds <- diamonds[sample(1:dim(diamonds)[1], 1000), ]
ggplot(sub_diamonds, aes(x = carat, y = price)) +
  geom_point()


## ----scatter-color-1,fig.cap="散点图配色"--------------------------------
ggplot(sub_diamonds, aes(x = carat, y = price)) +
  geom_point(color = "steelblue")


## ----scatter-scale-1,fig.cap="格式化坐标轴刻度标签"----------------------
ggplot(sub_diamonds, aes(x = carat, y = price)) +
  geom_point(color = "steelblue") +
  scale_y_continuous(
    labels = scales::unit_format(unit = "k", scale = 1e-3),
    breaks = seq(0, 20000, 4000)
  )


## ----scatter-color-2,fig.cap="分类散点图"--------------------------------
ggplot(sub_diamonds, aes(x = carat, y = price, color = cut)) +
  geom_point()


## ----scatter-group,fig.cap="分组"----------------------------------------
ggplot(sub_diamonds, aes(x = carat, y = price, group = cut)) +
  geom_point()


## ----group-lm,fig.cap="分组线性回归",fig.ncol=1--------------------------
ggplot(sub_diamonds, aes(x = carat, y = price)) +
  geom_point() +
  geom_smooth(method = "lm")
ggplot(sub_diamonds, aes(x = carat, y = price, group = cut)) +
  geom_point() +
  geom_smooth(method = "lm")


## ----fig.cap="局部多项式平滑"--------------------------------------------
ggplot(sub_diamonds, aes(x = carat, y = price, group = cut)) +
  geom_point() +
  geom_smooth(method = "loess")

## ----group-gam,fig.cap="数据分组应用广义可加平滑"------------------------
ggplot(sub_diamonds, aes(x = carat, y = price, group = cut)) +
  geom_point() +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"))


## ----group-facet,fig.cap=c("分组分面","分组配色"),fig.ncol=1-------------
ggplot(sub_diamonds, aes(x = carat, y = price, group = cut)) +
  geom_point() +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs")) +
  facet_grid(~cut)
ggplot(sub_diamonds, aes(x = carat, y = price, group = cut, color = cut)) +
  geom_point() +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"))


## ----scatter-facet,fig.cap="分面散点图"----------------------------------
ggplot(sub_diamonds, aes(x = carat, y = price)) +
  geom_point() +
  facet_grid(~cut)


## ----scatter-facet-color-1,fig.cap="给分面散点图上色"--------------------
ggplot(sub_diamonds, aes(x = carat, y = price)) +
  geom_point(color = "steelblue") +
  facet_grid(~cut)


## ----scatter-facet-color-2,fig.cap="给不同的类上不同的颜色"--------------
ggplot(sub_diamonds, aes(x = carat, y = price, color = cut)) +
  geom_point() +
  facet_grid(~cut)


## ----scatter-facet-color-3,fig.cap="去掉图例"----------------------------
ggplot(sub_diamonds, aes(x = carat, y = price, color = cut)) +
  geom_point(show.legend = FALSE) +
  facet_grid(~cut)


## ----fig.cap="多个图例"--------------------------------------------------
data(Wheat2, package = "nlme") # Wheat Yield Trials
library(colorspace)
ggplot(Wheat2, aes(longitude, latitude)) +
  geom_point(aes(size = yield, colour = Block)) +
  scale_color_discrete_sequential(palette = "Viridis") +
  scale_x_continuous(breaks = seq(0, 30, 5)) +
  scale_y_continuous(breaks = seq(0, 50, 10))


## ----category-ggplot,fig.cap="分类散点图"--------------------------------
ggplot(mtcars, aes(x = hp, y = mpg, color = factor(am))) +
  geom_point() +
  theme_bw()


## ----fig.cap="1948年至1960年航班乘客人数变化"----------------------------
dat <- as.data.frame(cbind(rep(1948 + seq(12), each = 12), rep(seq(12), 12), AirPassengers))
colnames(dat) <- c("year", "month", "passengers")

ggplot(data = dat, aes(x = as.factor(year), y = as.factor(month))) +
  stat_sum(aes(size = passengers), colour = "lightblue") +
  scale_size(range = c(1, 10), breaks = seq(100, 650, 50)) +
  labs(x = "Year", y = "Month", colour = "Passengers") +
  theme_minimal()


## ------------------------------------------------------------------------
data("PlantGrowth")
str(PlantGrowth)


## ----PlantGrowth-boxplot-------------------------------------------------
ggplot(data = PlantGrowth, aes(x = group, y = weight)) + geom_boxplot()


## ----PlantGrowth-jitter--------------------------------------------------
ggplot(data = PlantGrowth, aes(x = group, y = weight, shape = group)) + geom_jitter()
ggplot(data = PlantGrowth, aes(x = group, y = weight, color = group)) + geom_jitter()


## ----fig.asp=0.8---------------------------------------------------------
boxplot(weight ~ group,
  data = PlantGrowth,
  ylab = "Dried weight of plants", col = "lightgray",
  notch = FALSE, varwidth = TRUE
)


## ----boxplot-facet-color,fig.cap="箱线图"--------------------------------
ggplot(diamonds, aes(x = color, y = price, color = cut)) +
  geom_boxplot(show.legend = FALSE) +
  facet_grid(~cut)


## ----boxplot-facet-color-clarity-1,fig.cap="复合分面箱线图"--------------
ggplot(diamonds, aes(x = color, y = price, color = cut)) +
  geom_boxplot(show.legend = FALSE) +
  facet_grid(clarity ~ cut)


## ----boxplot-facet-color-clarity-2,fig.cap=c("切割质量cut上色","钻石颜色配色"),fig.ncol=1----
ggplot(diamonds, aes(x = cut, y = price, color = cut)) +
  geom_boxplot(show.legend = FALSE) +
  facet_grid(clarity ~ color)
ggplot(diamonds, aes(x = cut, y = price, color = color)) +
  geom_boxplot(show.legend = FALSE) +
  facet_grid(clarity ~ color)


## ----eval=FALSE----------------------------------------------------------
## # 需要映射数据框的两个变量，相当于自己先计算了每类的数量
## with(diamonds, table(cut))
## cut_df <- as.data.frame(table(diamonds$cut))
## ggplot(cut_df, aes(x = Var1, y = Freq)) + geom_bar(stat = "identity")

## ----diamonds-barplot-1,fig.cap="频数条形图"-----------------------------
ggplot(diamonds, aes(x = cut)) + geom_bar()


## ----eval=FALSE----------------------------------------------------------
## ggplot(diamonds, aes(x = cut)) + geom_bar(stat = "count")
## ggplot(diamonds, aes(x = cut, y = ..count..)) + geom_bar()
## ggplot(diamonds, aes(x = cut, y = stat(count))) + geom_bar()


## ----diamonds-barplot-2,fig.cap="堆积条形图"-----------------------------
ggplot(diamonds, aes(x = cut, fill = clarity)) + geom_bar()


## ----diamonds-barplot-3,fig.cap="分面堆积条形图"-------------------------
ggplot(diamonds, aes(x = color, fill = clarity)) +
  geom_bar() +
  facet_grid(~cut)


## ------------------------------------------------------------------------
with(diamonds, table(cut, color))


## ----diamonds-barplot-4,fig.cap="比例堆积条形图"-------------------------
ggplot(diamonds, aes(x = color, fill = clarity)) +
  geom_bar(position = "fill") +
  facet_grid(~cut)


## ----diamonds-barplot-5,fig.cap="复合条形图"-----------------------------
ggplot(diamonds, aes(x = color, fill = clarity)) +
  geom_bar(position = "dodge")


## ----diamonds-barplot-6,fig.cap="分面复合条形图"-------------------------
ggplot(diamonds, aes(x = color, fill = clarity)) +
  geom_bar(position = "dodge") +
  facet_grid(rows = vars(cut))


## ------------------------------------------------------------------------
with(diamonds, table(color, clarity, cut))


## ----fig.cap="时序图"----------------------------------------------------
ggplot(economics, aes(date, unemploy)) + geom_line()


## ----fig.cap="钻石价格的分布"--------------------------------------------
ggplot(diamonds, aes(price)) + geom_histogram(bins = 30)


## ----fig.cap="钻石价格随切割质量的分布"----------------------------------
ggplot(diamonds, aes(x = price, fill = cut)) + geom_histogram(bins = 30)


## ----fig.cap="直方图",fig.subcap=c("Base R 直方图","Ggplot2 直方图")-----
par(mar = c(2.1, 2.1, 1.5, 0.5))
plot(c(50, 350), c(0, 10),
  type = "n", font.main = 1,
  xlab = "", ylab = "", frame.plot = FALSE, axes = FALSE,
  # xlab = "hp", ylab = "Frequency",
  main = paste("Histogram with Base R", paste(rep(" ", 60), collapse = ""))
)
axis(
  side = 1, at = seq(50, 350, 50), labels = seq(50, 350, 50),
  tick = FALSE, las = 1, padj = 0, mgp = c(3, 0.1, 0)
)
axis(
  side = 2, at = seq(0, 10, 2), labels = seq(0, 10, 2),
  # col = "white", 坐标轴的颜色
  # col.ticks 刻度线的颜色
  tick = FALSE, # 取消刻度线
  las = 1, # 水平方向
  hadj = 1, # 右侧对齐
  mgp = c(3, 0.1, 0) # 纵轴边距线设置为 0.1
)
abline(h = seq(0, 10, 2), v = seq(50, 350, 50), col = "gray90", lty = "solid")
abline(h = seq(1, 9, 2), v = seq(75, 325, 50), col = "gray95", lty = "solid")
hist(mtcars$hp,
  col = "#56B4E9", border = "white",
  freq = TRUE, add = TRUE
  # labels = TRUE, axes = TRUE, ylim = c(0, 10.5),
  # xlab = "hp",main = "Histogram with Base R"
)
mtext("hp", 1, line = 1.0)
mtext("Frequency", 2, line = 1.0)

ggplot(mtcars) +
  geom_histogram(aes(x = hp), fill = "#56B4E9", color = "white", breaks = seq(50, 350, 50)) +
  scale_x_continuous(breaks = seq(50, 350, 50)) +
  scale_y_continuous(breaks = seq(0, 12, 2)) +
  labs(x = "hp", y = "Frequency", title = "Histogram with Ggplot2") +
  theme_minimal(base_size = 12)


## ----violin,fig.cap=c("箱线图","小提琴图"),fig.ncol=1--------------------
ggplot(diamonds, aes(x = cut, y = price)) + geom_boxplot()
ggplot(diamonds, aes(x = cut, y = price)) + geom_violin()


## ----violin-mpg,fig.cap="城市里程与车辆类别"-----------------------------
ggplot(mpg, aes(class, cty)) +
  geom_violin() +
  labs(
    title = "Violin plot",
    subtitle = "City Mileage vs Class of vehicle",
    caption = "Source: mpg",
    x = "Class of Vehicle",
    y = "City Mileage"
  ) +
  theme_minimal()


## ------------------------------------------------------------------------
ggplot(mpg, aes(x = class, y = hwy, color = class)) +
  ggbeeswarm::geom_quasirandom()


## ------------------------------------------------------------------------
ggplot(mpg, aes(x = class, y = hwy, color = class)) + geom_jitter()


## ----fig.cap="抖动图的反例"----------------------------------------------
ggplot(sub_diamonds, aes(x = cut, y = price)) + geom_jitter()


## ----fig.cap="根据钻石颜色上色"------------------------------------------
ggplot(sub_diamonds, aes(x = color, y = price, color = color)) +
  geom_jitter() +
  facet_grid(clarity ~ cut)


## ----fig.cap="箱线图"----------------------------------------------------
ggplot(diamonds, aes(x = color, y = price, color = color)) +
  geom_boxplot() +
  facet_grid(cut ~ clarity)


## ------------------------------------------------------------------------
ggplot(diamonds, aes(x = color, y = price, color = color)) +
  geom_boxplot() +
  facet_grid(~clarity)


## ------------------------------------------------------------------------
ggplot(diamonds, aes(x = color, y = price, color = color)) +
  geom_boxplot()


## ------------------------------------------------------------------------
ggplot(diamonds) +
  ggridges::geom_density_ridges(aes(y = color, x = price, fill = color))


## ----fig.cap="按汽缸数分组的城市里程"------------------------------------
ggplot(mpg, aes(cty)) +
  geom_density(aes(fill = factor(cyl)), alpha = 0.8) +
  labs(
    title = "Density plot",
    subtitle = "City Mileage Grouped by Number of cylinders",
    caption = "Source: mpg",
    x = "City Mileage",
    fill = "# Cylinders"
  )


## ----density,fig.cap=c("密度图","添加透明度的密度图"),fig.ncol=1---------
ggplot(diamonds, aes(x = price, fill = cut)) + geom_density()
ggplot(diamonds, aes(x = price, fill = cut)) + geom_density(alpha = 0.5)


## ----stack-density,fig.cap="堆积密度图"----------------------------------
ggplot(diamonds, aes(x = price, fill = cut)) + 
  geom_density(position = "stack")


## ----fig.cap="条件密度估计图"--------------------------------------------
# You can use position="fill" to produce a conditional density estimate
ggplot(diamonds, aes(carat, stat(count), fill = cut)) +
  geom_density(position = "fill")


## ------------------------------------------------------------------------
ggplot(diamonds) +
  ggridges::geom_density_ridges(aes(x = price, y = color, fill = color))


## ------------------------------------------------------------------------
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_density_2d(aes(color = cut)) +
  facet_grid(~cut) +
  scale_fill_viridis_d()


## ------------------------------------------------------------------------
ggplot(diamonds, aes(x = carat, y = price)) +
  stat_density_2d(aes(fill = stat(nlevel)), geom = "polygon") +
  facet_grid(. ~ cut) + scale_fill_viridis_c()


## ------------------------------------------------------------------------
ggplot(diamonds, aes(x = carat, y = price)) + geom_hex() +
  scale_fill_viridis_c()


## ----stack-to-rose,fig.cap="堆积条形图转风玫瑰图"------------------------
ggplot(diamonds, aes(x = color, fill = clarity)) +
  geom_bar()
ggplot(diamonds, aes(x = color, fill = clarity)) +
  geom_bar() +
  coord_polar()


## ----wind-rose,fig.cap="风玫瑰图"----------------------------------------
# 风玫瑰图 http://blog.csdn.net/Bone_ACE/article/details/47624987
library(ggplot2)
set.seed(2018)
# 随机生成100次风向，并汇集到16个区间内
direction <- cut_interval(runif(100, 0, 360), n = 16)
# 随机生成100次风速，并划分成4种强度
mag <- cut_interval(rgamma(100, 15), 4)
dat <- data.frame(direction = direction, mag = mag)
# 将风向映射到X轴，频数映射到Y轴，风速大小映射到填充色，生成条形图后再转为极坐标形式即可
p <- ggplot(dat, aes(x = direction, y = ..count.., fill = mag))
p + geom_bar(colour = "white") +
  coord_polar() +
  theme_minimal() +
  theme(axis.ticks = element_blank(), axis.text.y = element_blank()) +
  labs(x = "", y = "", fill = "Magnitude")

# p + geom_bar(position = "stack") +
#   coord_polar() +
#   theme_minimal() +
#   theme(axis.ticks = element_line(colour = "white"))


## ------------------------------------------------------------------------
crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
crimesm <- reshape2::melt(crimes, id = 1)
head(crimesm)


## ------------------------------------------------------------------------
library(maps)
states_map <- map_data("state")
head(states_map)


## ----fig.cap="1973年美国各州的犯罪率数据"--------------------------------
ggplot(crimes, aes(map_id = state)) +
  geom_map(aes(fill = Murder), map = states_map) +
  expand_limits(x = states_map$long, y = states_map$lat) +
  coord_map()


## ----fig.cap="四类犯罪在各州的分布"--------------------------------------
ggplot(crimesm, aes(map_id = state)) +
  geom_map(aes(fill = value), map = states_map) +
  expand_limits(x = states_map$long, y = states_map$lat) +
  facet_wrap(~variable)


## ----pickcolor,fig.cap="viridis 和 Spectral对比"-------------------------
dat <- as.data.frame(cbind(rep(1948 + seq(12), each = 12), rep(seq(12), 12), AirPassengers))
colnames(dat) <- c("year", "month", "passengers")
# library(colormap)
ggplot(data = dat, aes(as.factor(year), as.factor(month))) +
  geom_point(aes(colour = passengers), pch = 15, size = 8) +
  scale_colour_distiller(palette = "Spectral") +
  labs(x = "Year", y = "Month") +
  theme_minimal()


## ----faithfuld,fig.cap="美国黄石国家公园的老忠实泉"----------------------
library(gridExtra)
erupt <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_raster() +
  scale_x_continuous(NULL, expand = c(0, 0)) +
  scale_y_continuous(NULL, expand = c(0, 0)) +
  theme(legend.position = "none")
erupt1 <- erupt + scale_fill_gradientn(colours = gray.colors(7))
erupt2 <- erupt + scale_fill_distiller(palette = "Spectral")
erupt3 <- erupt + scale_fill_gradientn(colours = terrain.colors(7))
erupt4 <- erupt
grid.arrange(erupt1, erupt2, erupt3, erupt4, ncol = 2)


## ----fiji-map,fig.cap="斐济地震带"---------------------------------------
library(mapdata)
FijiMap <- map_data("worldHires", region = "Fiji")
ggplot(FijiMap, aes(x = long, y = lat)) +
  geom_map(map = FijiMap, aes(map_id = region), size = .2) +
  geom_point(data = quakes, aes(x = long, y = lat, colour = mag), pch = 16) +
  xlim(160, 195) +
  scale_colour_distiller(palette = "Spectral") +
  scale_y_continuous(breaks = (-18:18) * 5) +
  coord_map("ortho", orientation = c(-10, 180, 0)) +
  labs(colour = "Magnitude", x = "Longitude", y = "Latitude") +
  theme_bw()


## ----unemploymentGG,fig.cap="2009年美国各城镇失业率"---------------------
# 数据来源 http://datasets.flowingdata.com/unemployment09.csv
unemp <- read.csv(
  file = "http://datasets.flowingdata.com/unemployment09.csv",
  header = FALSE, stringsAsFactors = FALSE
)
names(unemp) <- c(
  "id", "state_fips", "county_fips", "name", "year",
  "?", "?", "?", "rate"
)
unemp$county <- tolower(gsub(" County, [A-Z]{2}", "", unemp$name))
unemp$state <- gsub("^.*([A-Z]{2}).*$", "\\1", unemp$name)

county_df <- map_data("county")
names(county_df) <- c("long", "lat", "group", "order", "state_name", "county")
county_df$state <- state.abb[match(county_df$state_name, tolower(state.name))]
county_df$state_name <- NULL

state_df <- map_data("state")
# Combine together
choropleth <- merge(county_df, unemp, by = c("state", "county"))
choropleth <- choropleth[order(choropleth$order), ]
choropleth$rate_d <- cut(choropleth$rate, breaks = c(seq(0, 10, by = 2), 35))

library(ggthemes)
ggplot(choropleth, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = rate_d), colour = alpha("white", 1 / 4), size = 0.2) +
  geom_polygon(data = state_df, colour = "white", fill = NA) +
  scale_fill_brewer(palette = "PuRd") +
  labs(
    fill = "ratio of unemployment", title = "unemployment by county, 2009",
    caption = "data source: http://datasets.flowingdata.com/unemployment09.csv"
  ) +
  coord_map("polyconic") +
  theme_map()


## ------------------------------------------------------------------------
methods(plot)


## ------------------------------------------------------------------------
getAnywhere(plot.raster)


## ------------------------------------------------------------------------
getAnywhere(rasterImage)


## ----fig.cap="raster 图像",dev.args=list(bg = "thistle"),warning=FALSE,fig.asp=1,out.width="50%",fig.width=30/7----
plot(c(100, 250), c(300, 450), type = "n", xlab = "", ylab = "")
image <- as.raster(matrix(0:1, ncol = 5, nrow = 3))
rasterImage(image, 100, 300, 150, 350, interpolate = FALSE)
rasterImage(image, 100, 400, 150, 450)
rasterImage(image, 200, 300, 200 + xinch(.5), 300 + yinch(.3),
  interpolate = FALSE
)
rasterImage(image, 200, 400, 250, 450, angle = 15, interpolate = FALSE)


## ------------------------------------------------------------------------
# https://resources.rstudio.com/rstudio-conf-2019/spatial-data-science-in-the-tidyverse
library(abind)
library(sf)
library(stars)
x <- system.file("tif/L7_ETMs.tif", package = "stars") %>%
  read_stars()
ggplot() +
  geom_stars(data = x) +
  coord_equal() +
  facet_wrap(~band) +
  theme_void() +
  scale_fill_viridis_c() +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0))


## ----fig.cap="气泡图"----------------------------------------------------
library(sp)
data(meuse)
coords <- SpatialPoints(meuse[c("x", "y")])
meuse <- SpatialPointsDataFrame(coords, meuse)
plot(meuse, pch = 1, cex = .05 * sqrt(meuse$zinc))


## ------------------------------------------------------------------------
library(maptools)
fname <- system.file("shapes/sids.shp", package = "maptools")
p4s <- CRS("+proj=longlat +datum=NAD27")
nc <- readShapePoly(fname, proj4string = p4s)
plot(nc, axes = TRUE, col = grey(1 - nc$SID79 / 57))


## ------------------------------------------------------------------------
# Trellis maps
arrow <- list("SpatialPolygonsRescale",
  layout.north.arrow(2),
  offset = c(-76, 34), scale = 0.5, which = 2
)
spplot(nc, c("SID74", "SID79"),
  as.table = TRUE,
  scales = list(draw = T), sp.layout = arrow
)


## ----eval=FALSE----------------------------------------------------------
## # library(dplyr, warn.conflicts = FALSE)
## nc <- system.file("gpkg/nc.gpkg", package = "sf") %>% read_sf()
## nc2 <- nc %>%
##   dplyr::select(SID74, SID79) %>%
##   tidyr::gather(VAR, SID, -geom)
## ggplot() +
##   geom_sf(data = nc2, aes(fill = SID)) +
##   facet_wrap(~VAR, ncol = 1)


## ----eval=FALSE----------------------------------------------------------
## library(GADMTools) # 会自动加载 tidyverse 包
## data("Corsica")
## # basefile 文件存放路径
## # FRA Corse 的国家代码
## gadm_sf_loadCountries("FRA", basefile = "./data/") %>%
##   gadm_plot(map) + theme_minimal()


## ------------------------------------------------------------------------
library(maps) # For map data
library(mapdata)
east_asia <- map_data("worldHires", region = c("Japan", "China", "North Korea", "South Korea"))

# Map region to fill color
ggplot(east_asia, aes(x = long, y = lat, group = group, fill = region)) +
  geom_polygon(colour = "black") +
  scale_fill_brewer(palette = "Set2")


## ----eval=FALSE----------------------------------------------------------
## BiocManager::install("Rgraphviz", version = "3.9")


## ----eval=FALSE----------------------------------------------------------
## library(DiagrammeR)
## svg <- DiagrammeRsvg::export_svg(
##   grViz("
## digraph neato {
## 
## graph [layout = neato]
## 
## node [shape = circle,
##       style = filled,
##       color = grey,
##       label = '']
## 
## node [fillcolor = red]
## yihui_pkgs$Package
## 
## node [fillcolor = green]
## unique(unlist(ctb))
## 
## node [fillcolor = orange]
## 
## edge [color = grey]
## yihui_pkgs$Package[1] -> ctb[[1]]
## yihui_pkgs$Package[2] -> ctb[[2]]
## yihui_pkgs$Package[3] -> ctb[[3]]
## yihui_pkgs$Package[4] -> ctb[[4]]
## }")
## )
## # this can then be used with htmltools and can save significantly
## # on size of output using svg rather than unrendered grViz
## library(htmltools)
## HTML(svg) # 将输出结果保存在svg格式矢量文件 即可
## html_print(HTML(svg))


## ----eval=FALSE----------------------------------------------------------
## # https://smallstats.blogspot.jp/2012/12/loading-huge-graphs-with-igraph-and-r.html
## # Loading huge graphs with igraph and R
## df <- data.frame(
##   src = sample(1:1000, 1000000, replace = TRUE),
## 
##   dst = sample(1:1000, 1000000, replace = TRUE)
## )
## 
## library(igraph)
## cat("--- Creating data.frame ---")
## start <- proc.time()
## df <- data.frame(
##   src = sample(1:1000, 10000000, replace = TRUE),
##   dst = sample(1:1000, 10000000, replace = TRUE)
## )
## 
## cat(sprintf("— elapsed time: %fs ", (proc.time() - start)[1]))
## cat("— Creating graph… ")
## start <- proc.time()
## G <- graph.data.frame(df, directed = TRUE)
## cat(sprintf("---elapsed user-time: %fs ", (proc.time() - start)[1]))
## 
## 
## cat("...Creating graph...")
## 
## start <- proc.time()
## 
## vertex.attrs <- list(name = unique(c(df$src, df$dst)))
## edges <- rbind(
##   match(df$src, vertex.attrs$name),
##   match(df$dst, vertex.attrs$name)
## )
## 
## G <- graph.empty(n = 0, directed = T)
## G <- add.vertices(G, length(vertex.attrs$name), attr = vertex.attrs)
## G <- add.edges(G, edges)
## 
## remove(edges)
## remove(vertex.attrs)
## 
## cat(sprintf("--- elapsed user-time: %fs ", (proc.time() - start)[1]))


## ---- echo=TRUE----------------------------------------------------------
# CRAN R 包 metadata 信息
if (file.exists("data/packages.rds")) {
  pdb <- readRDS("data/packages.rds")
} else {
  pdb <- readRDS(file = file(sprintf("%s/web/packages/packages.rds", getOption("repos")["CRAN"])))
}


## ------------------------------------------------------------------------
length(pdb[, "Package"])


## ------------------------------------------------------------------------
pdb[, "Package"][duplicated(pdb[, "Package"])]


## ------------------------------------------------------------------------
dim(subset(pdb, subset = !duplicated(pdb[, "Package"])))[1]


## ------------------------------------------------------------------------
pdb <- subset(pdb, subset = !duplicated(pdb[, "Package"]))


## ------------------------------------------------------------------------
core_pdb <- subset(pdb,
  subset = grepl(
    x = pdb[, "Maintainer"],
    pattern = "(@R-project\\.org)"
  ),
  select = c("Package", "Maintainer")
)
dim(core_pdb[order(core_pdb[, "Maintainer"]), ])


## ------------------------------------------------------------------------
subset(pdb, subset = grepl(x = pdb[, "Maintainer"], pattern = "(Paul Murrell)"), 
                   select = c("Package", "Maintainer"))


## ------------------------------------------------------------------------
core_team <- read.table(
  text = "
Douglas Bates
John Chambers
Peter Dalgaard
Robert Gentleman
Kurt Hornik
Ross Ihaka
Tomas Kalibera
Michael Lawrence
Friedrich Leisch
Uwe Ligges
Thomas Lumley
Martin Maechler
Martin Morgan
Paul Murrell
Martyn Plummer
Brian Ripley
Deepayan Sarkar
Duncan Temple Lang
Luke Tierney
Simon Urbanek
Heiner Schwarte
Guido Masarotto
Stefano Iacus
Seth Falcon
Duncan Murdoch
David Meyer
Simon Wood
", header = FALSE, sep = "\n", check.names = FALSE, stringsAsFactors = FALSE,
  colClasses = "character", comment.char = "", col.names = "name"
)


## ------------------------------------------------------------------------
core_pdb <- subset(pdb,
  subset = grepl(
    x = pdb[, "Maintainer"],
    pattern = paste("(", core_team$name, ")", collapse = "|", sep = "")
  ),
  select = c("Package", "Maintainer", "Published")
)


## ------------------------------------------------------------------------
clean_maintainer <- function(x) {
  # 去掉邮箱
  x <- gsub("<([^<>]*)>", "", x)
  # 去掉 \n \t \' \" 和 '
  x <- gsub("(\\\n)|(\\\t)|(\\\")|(\\\')|(')", "", x)
  # 去掉末尾空格
  x <- gsub(" +$", "", x)
}
core_pdb[, "Maintainer"] <- clean_maintainer(core_pdb[, "Maintainer"])


## ------------------------------------------------------------------------
dim(core_pdb)


## ----r-core-team---------------------------------------------------------
knitr::kable(head(core_pdb[order(
  core_pdb[, "Maintainer"],
  core_pdb[, "Published"]
), ], 10),
caption = "R Core Team 维护的 R 包（展示部分）", booktabs = TRUE
)


## ------------------------------------------------------------------------
sort(table(core_pdb[, "Maintainer"]), decreasing = TRUE)


## ----rmarkdown-ecology---------------------------------------------------
yihui_pdb <- subset(pdb,
  subset = grepl("Yihui Xie", pdb[, "Maintainer"]),
  select = c("Package", "Maintainer", "Title")
)
yihui_pdb[, "Title"] <- gsub("(\\\n)", " ", yihui_pdb[, "Title"])
knitr::kable(yihui_pdb, caption = "谢益辉维护的 R Markdown 生态", booktabs = TRUE)


## ------------------------------------------------------------------------
subset(pdb, subset = grepl("Jeroen Ooms", pdb[, "Maintainer"]),
       select = 'Package', drop = TRUE)


## ------------------------------------------------------------------------
subset(pdb, subset = grepl("Dirk Eddelbuettel", pdb[, "Maintainer"]),
       select = 'Package', drop = TRUE)


## ------------------------------------------------------------------------
subset(pdb, subset = grepl("Hadley Wickham", pdb[, "Maintainer"]),
       select = 'Package', drop = TRUE)


## ------------------------------------------------------------------------
subset(pdb, subset = grepl("Scott Chamberlain", pdb[, "Maintainer"]),
       select = 'Package', drop = TRUE)


## ------------------------------------------------------------------------
length(unique(pdb[, "Maintainer"]))


## ------------------------------------------------------------------------
subset(pdb,
  subset = grepl("Hadley Wickham", pdb[, "Maintainer"]),
  select = c("Package", "Maintainer")
)


## ------------------------------------------------------------------------
pdb[, "Maintainer"] <- clean_maintainer(pdb[, "Maintainer"])
length(unique(pdb[, "Maintainer"]))


## ----top-maintainers,fig.cap="(ref:top-maintainers)",fig.asp=1,fig.width=5.5,out.width="55%"----
top_maintainer <- head(sort(table(pdb[, "Maintainer"]), decreasing = TRUE), 20)

par(mar = c(2, 7, 1, 1))
barCenters <- barplot(top_maintainer,
  col = "lightblue", axes = FALSE,
  axisnames = FALSE, horiz = TRUE, border = "white"
)
text(
  y = barCenters, x = par("usr")[3],
  adj = 1, labels = names(top_maintainer), xpd = TRUE
)
axis(1,
  labels = seq(0, 90, by = 10), at = seq(0, 90, by = 10),
  las = 1, col = "gray"
)
grid()


## ------------------------------------------------------------------------
top_maintainer <- as.data.frame(top_maintainer)
colnames(top_maintainer) <- c("Maintainer", "Freq")

ggplot(top_maintainer) +
  geom_bar(aes(x = Maintainer, y = Freq), stat = "identity") +
  coord_flip() +
  xlab("Maintainer") +
  ylab("Numbers of Package")


## ------------------------------------------------------------------------
ggplot(top_maintainer, aes(x = Freq, y = Maintainer)) +
  geom_segment(aes(x = 20, xend = Freq, yend = Maintainer), colour = "grey50") +
  geom_point(size = 2, colour = "red") +
  labs(x = " # of Packages ", y = " Maintainer ")


## ------------------------------------------------------------------------
barplot(table(table(pdb[, "Maintainer"])), 
        col = "lightblue", log = "y", border = "white", 
        xlab = "# of Packages", ylab = "# of Maintainers (log)",
        panel.first = grid())


## ------------------------------------------------------------------------
sub_pdb <- subset(pdb, select = c("Package", "Maintainer", "Author"))


## ------------------------------------------------------------------------
clean_author <- function(x) {
  # 去掉中括号及其内容 [aut] [aut, cre]
  x <- gsub("(\\[.*?\\])", "", x)
  # 去掉小括号及其内容 ()
  x <- gsub("(\\(.*?\\))", "", x)
  # 去掉尖括号及其内容 < >
  x <- gsub("(<.*?>)", "", x)
  # 去掉 \n
  x <- gsub("(\\\n)", "", x)
  # 去掉制表符、双引号、单引号和 \'，如 'Hadley Wickham' 中的单引号 ' 等
  x <- gsub("(\\\t)|(\\\")|(\\\')|(')|(\\))", "", x)
  # Christian P. Robert, Universite Paris Dauphine, and Jean-Michel\n        Marin, Universite Montpellier 2
  x <- gsub("(and)", "", x)
  # 两个以上的空格替换为一个空格
  x <- gsub("( {2,})"," ",x)
  x
}

sub_pdb[, "Maintainer"] <- clean_maintainer(sub_pdb[, "Maintainer"])
sub_pdb[, "Author"] <- clean_author(sub_pdb[, "Author"])


## ------------------------------------------------------------------------
length(unique(sub_pdb[, "Maintainer"][duplicated(sub_pdb[, "Maintainer"])]))


## ------------------------------------------------------------------------
first_ctb <- setdiff(
  sub_pdb[, "Maintainer"][!duplicated(sub_pdb[, "Maintainer"])],
  unique(sub_pdb[, "Maintainer"][duplicated(sub_pdb[, "Maintainer"])])
)


## ------------------------------------------------------------------------
ctb_num <- unlist(
  lapply(
    strsplit(
      subset(sub_pdb,
             subset = sub_pdb[, "Maintainer"] %in% first_ctb,
             select = "Author"
      ),
      split = ","
    ), length
  )
) 
hist(ctb_num, col = "lightblue", border = "white", probability = TRUE, labels = TRUE,
     xlab = "# of Contributors", ylab = "Proportion", main = "",
     panel.first = grid(), xlim = c(0, 10))


## ------------------------------------------------------------------------
table(ctb_num)


## ------------------------------------------------------------------------
# 找到开发者
first_ctb[which.max(ctb_num)]
# 找到 R 包
subset(sub_pdb, subset = grepl("Matt Dowle", sub_pdb[, "Maintainer"]), select = "Package")


## ------------------------------------------------------------------------
net_pdb <- subset(pdb, select = c("Maintainer", "Author"))
net_pdb[, "Maintainer"] <- clean_maintainer(net_pdb[, "Maintainer"])
total_maintainer <- unique(net_pdb[, "Maintainer"])
clean_author <- function(maintainer) {
  sapply(net_pdb[, "Author"], grepl, pattern = paste0("(", maintainer, ")"))
}


## ----eval=FALSE----------------------------------------------------------
## maintainer_author <- Reduce("cbind", lapply(total_maintainer, clean_author))
## colnames(maintainer_author) <- total_maintainer
## rownames(maintainer_author) <- net_pdb[, "Maintainer"]


## ----eval=FALSE----------------------------------------------------------
## saveRDS(maintainer_author, file = "data/maintainer_author.rds")
## write.table(maintainer_author,file = "data/maintainer_author.csv", row.names = TRUE, col.names = TRUE)

## ----echo=FALSE----------------------------------------------------------
maintainer_author <- readRDS(file = "data/maintainer_author.rds")


## ------------------------------------------------------------------------
format(object.size(maintainer_author), units = "auto")


## ------------------------------------------------------------------------
max(rowSums(maintainer_author))
max(colSums(maintainer_author))


## ------------------------------------------------------------------------
hist(colSums(maintainer_author)[colSums(maintainer_author) <= 10], 
     probability = FALSE, xlab = "", main = "")


## ------------------------------------------------------------------------
hist(rowSums(maintainer_author)[rowSums(maintainer_author) <= 20], 
     xlab = "", main = "",probability = FALSE)


## ------------------------------------------------------------------------
# 非零元素最多的行
max(rowMeans(maintainer_author))
# 非零元素最多的列
max(colMeans(maintainer_author))


## ------------------------------------------------------------------------
library(Matrix)
spM <- spMatrix(3, 4, i = c(1, 1, 2, 3, 3), 
                j = c(4, 1, 2, 1, 3),
                x = c(4, 4, 1, 4, 8))
spM
image(spM)


## ------------------------------------------------------------------------
update_pdb <- as.data.frame(pdb[, c("Package", "Published")], stringsAsFactors = FALSE)
# 这天要更新的R包最多
sort(table(update_pdb[,"Published"]), decreasing = TRUE)[1]

ggplot(update_pdb, aes(as.Date(Published))) +
  geom_bar(color = "skyblue4") +
  geom_line(
    data = data.frame(
      date = as.Date(c("2011-01-01", "2012-10-20")),
      count = c(80, 100)
    ), aes(x = date, y = count),
    arrow = arrow(angle = 15, length = unit(0.15, "inches"))
  ) +
  annotate("text", x = as.Date("2010-11-01"), y = 75, label = "(2012-10-29,130)") +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(x = "Published Date", y = "Count") +
  theme_minimal()


## ----eval=FALSE,echo=FALSE-----------------------------------------------
## subset(update_pdb, subset = update_pdb[, "Published"] == min(update_pdb[, "Published"]))
## update_pdb[which.min(as.Date(update_pdb[, "Published"])), 1]


## ------------------------------------------------------------------------
license_pdb <- head(sort(table(pdb[, "License"]), decreasing = TRUE), 20)
par(mar = c(2, 12, 0.5, 0))
plot(c(1, 1e1, 1e2, 1e3, 1e4), c(1, 5, 10, 15, 20),
     type = "n",panel.first = grid(),
     ann = FALSE, log = "x", axes = FALSE
)
axis(1,
     at = c(1, 1e1, 1e2, 1e3, 1e4),
     labels = expression(1, 10^1, 10^2, 10^3, 10^4)
)
text(
  y = seq(length(license_pdb)), x = 1, cex = 1, offset = 1,
  pos = 2, labels = names(license_pdb), xpd = TRUE
)
text(1e3, 15, "CRAN")
segments(x0 = 1, y0 = seq(length(license_pdb)), 
         x1 = license_pdb, y1 = seq(length(license_pdb)), 
         col = "lightblue", lwd = 4)


## ------------------------------------------------------------------------
rforge_pdb <- available.packages(repos = "http://R-Forge.R-project.org")
license_rforge_pdb <- head(sort(table(rforge_pdb[, "License"]), decreasing = TRUE), 20)
par(mar = c(2, 12, 0.5, 0))
plot(c(1, 1e1, 1e2, 1e3), seq(from = 1, to = 20,length.out = 4),
  type = "n",panel.first = grid(),
  ann = FALSE, log = "x", axes = FALSE
)
axis(1,
  at = c(1, 1e1, 1e2, 1e3),
  labels = expression(1, 10^1, 10^2, 10^3)
)

text(
  y = seq(length(license_rforge_pdb)), x = 1, cex = 1, offset = 1,
  pos = 2, labels = names(license_rforge_pdb), xpd = TRUE
)
text(1e2, 15, "R-Forge")
segments(x0 = 1, y0 = seq(length(license_rforge_pdb)), 
         x1 = license_rforge_pdb, y1 = seq(length(license_rforge_pdb)), 
         lwd = 4, col = "lightblue")


## ------------------------------------------------------------------------
sessionInfo()

