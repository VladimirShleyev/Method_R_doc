from rpy2.robjects import pandas2ri # loading rpy2
from rpy2.robjects import r

pandas2ri.activate() # activating pandas module
df_iris_py = pandas2ri.ri2py(r['iris']) # from r data frame to pandas
df_iris_r = pandas2ri.py2ri(df_iris_py) # from pandas to r data frame
plotFunc = r("""
    library(ggplot2)
    function(df){
    p <- ggplot(iris, aes(x = Sepal.Length, y = Petal.Length))
            + geom_point(aes(color = Species))
            print(p)
    ggsave('iris_plot.pdf', plot = p, width = 6.5, height = 5.5) }
""") # ggplot2 example
gr = importr('grDevices') # necessary to shut the graph off plotFunc(df_iris_r)
gr.dev_off()
