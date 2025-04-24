
# FRED Data Variables ----------------------------------------------------------

if (FALSE) {
  lines <- read_lines("data/raw/README.txt")
  
  pat_limits <- "-----------------------------------------------------------------------------------------------------------------------------  ---------------  ----------"
  content_indexes <- (str_which(lines, pat_limits) + c(1, -1)) %>% {`:`(.[1], .[2])}
  
  lines <- lines[content_indexes]
  
  info_indexes <- list(
    id = str_which(lines, "^Series ID\\s{2,}") + 1,
    title = str_which(lines, "^Title$") + 1,
    units = str_which(lines, "^Units$") + 1
  )
  
  info <- map(info_indexes, ~ str_replace(lines[.x], "\\s{2,}.+$", ""))
  
  info_formated <- pmap_chr(info, function(id, title, units) {
    glue("| {id} | {title} | {units} |")
  })
  
  write_lines(info_formated, tempfile())
}




# Variable Groups ---------------------------------------------------------

get_variable_groups <- function() {
  lines_groups <- read_lines("data/modified/data_groups.txt") %>%
    split(., cumsum(str_detect(., "^# ")))
  
  map(lines_groups, function(g) {
    g <- str_subset(g, ".")
    list(str_trim(g[-1])) %>% set_names(str_remove(g[1], "^# "))
  }) %>%
    list_flatten(name_spec = "{inner}") %>%
    list_modify("Policy operations" = zap())
}
