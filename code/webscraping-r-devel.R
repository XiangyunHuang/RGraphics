# 安装必要的依赖
packages <- c("rvest", "knitr")
lapply(packages, function(pkg) {
  if (system.file(package = pkg) == "") install.packages(pkg)
})

# 确保 Windows 下的中文环境也能获取正确的日期格式化结果
Sys.setlocale("LC_TIME", "C")
# 格式化日期
all_months <- format(
  seq(
    from = as.Date("1997-04-01"),
    to = Sys.Date(), by = "1 month"
  ),
  "%Y-%B"
)

# 清理帖子主题
clean_discuss_topic <- function(x) {
  # 去掉中括号及其内容
  x <- gsub("(\\[.*?\\])", "", x)
  # 去掉末尾换行符 \n
  x <- gsub("(\\\n)$", "", x)
  # 两个以上的空格替换为一个空格
  x <- gsub("( {2,})", " ", x)
  x
}
library(magrittr)
x <- "2019-February"
base_url <- "https://stat.ethz.ch/pipermail/r-devel"

# 下面的部分可以打包成一个函数
# 输入是日期 x 输出是一个 markdown 表格

scrap_webpage <- xml2::read_html(paste(base_url, x, "subject.html", sep = "/"))

# Extract the URLs 提取链接尾部
tail_url <- scrap_webpage %>%
  rvest::html_nodes("a") %>%
  rvest::html_attr("href")
# Extract the theme 提取链接对应的讨论主题
discuss_topic <- scrap_webpage %>%
  rvest::html_nodes("a") %>%
  rvest::html_text()

# url 和 讨论主题合并为数据框
discuss_df <- data.frame(discuss_topic = discuss_topic, tail_url = tail_url)

# 清理无效的帖子记录
discuss_df <- discuss_df[grepl(pattern = "\\.html$", x = discuss_df$tail_url), ]
# 清理帖子主题内容
discuss_df$discuss_topic <- clean_discuss_topic(discuss_df$discuss_topic)

# 去重 # 只保留第一条发帖记录
discuss_uni_df <- discuss_df[!duplicated(discuss_df$discuss_topic), ]
# 分组计数
discuss_count_df <- as.data.frame(table(discuss_df$discuss_topic), stringsAsFactors = FALSE)
# 对 discuss_count_df 的列重命名
colnames(discuss_count_df) <- c("discuss_topic", "count")
# 按讨论主题合并数据框
discuss <- merge(discuss_uni_df, discuss_count_df, by = "discuss_topic")

# 添加完整的讨论帖的 url
discuss <- transform(discuss, full_url = paste(base_url, x, tail_url, sep = "/"))
# 选取讨论主题、主题链接和楼层高度
discuss <- discuss[, c("discuss_topic", "full_url", "count")]

# 按楼层高度排序，转化为 Markdown 表格形式输出
discuss[order(discuss$count, decreasing = TRUE), ] %>%
  knitr::kable(format = "markdown", row.names = FALSE) %>%
  cat(file = paste0(x, "-disuss.md"), sep = "\n")
