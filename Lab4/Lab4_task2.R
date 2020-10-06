library(iterators)
library(tidyverse)

# прямолинейное решение ---------------
lab4 <- function(){
  setwd("~/Documents/бэкап с офисного ПК_xeon/R_projects/Method_R_doc/Lab4")
  
  e1 <- new.env(parent = baseenv())
  assign("x", 
         c(read.table("1.txt", sep = ",", header = FALSE)), 
         envir = e1 
  )
  
  e2 <- new.env(parent = baseenv())  
  assign("x", 
         c(read.table("2.txt", sep = ",", header = FALSE)), 
         envir = e2 
  )
  
  e3 <- new.env(parent = baseenv())  
  assign("x", 
         c(read.table("3.txt", sep = ",", header = FALSE)), 
         envir = e3 
  )   
  
  e4 <- new.env(parent = baseenv())  
  assign("x", 
         c(read.table("4.txt", sep = ",", header = FALSE)), 
         envir = e4 
  )
  
  e5 <- new.env(parent = baseenv())  
  assign("x", 
         c(read.table("5.txt", sep = ",", header = FALSE)), 
         envir = e5 
  )
  
  g1 <- function(x) return(x*2)
  g2 <- function(x) return(x^4)
  g3 <- function(x) return(sin(x))
  g4 <- function(x) return(cos(x))
  g5 <- function(x) return(tan(x))
  
  plot(c(0,0), c(0,0)) 
  for (f in c(g1, g2, g3, g4, g5)) plot(f, 0,1, add=T)
  
  df <- data.frame(
    rbind(get("x", envir = e1),
          get("x", envir = e2),
          get("x", envir = e3),
          get("x", envir = e4),
          get("x", envir = e5))
  )
  df
}

lab4()


# чуть более продвинутое решение --------------

lab4 <- function(){
      setwd("~/Documents/бэкап с офисного ПК_xeon/R_projects/Method_R_doc/Lab4")
      file_names <- c("1.txt", "2.txt", "3.txt", "4.txt", "5.txt")
      envir <<- c(e1 = new.env(), e2 = new.env(), e3 = new.env(), e4 = new.env(), e5 = new.env())
      
      element <- iter(envir)
      for (i in 1:5) {
         el <- nextElem(element)
         el$state$obj <- read.table(file_names[i])
      }
      
      df <- data.frame(strsplit(envir$e1$state$obj$V1, split = ","),
                  strsplit(envir$e2$state$obj$V1, split = ","),
                  strsplit(envir$e3$state$obj$V1, split = ","),
                  strsplit(envir$e4$state$obj$V1, split = ","),
                  strsplit(envir$e5$state$obj$V1, split = ",")
      )
      df$v1 <- df$c..1....2....3..
      df$v2 <- df$c..2....3....4..
      df$v3 <- df$c..4....5....6..
      df$v4 <- df$c..6....7....7..
      df$v5 <- df$c..8....9....0..

      df <- df[, 6:10]
      rm(el, element, file_names, i)
      
      ggplot(data = df)+
        geom_col(mapping = aes(x = v4, y = v3))
}

lab4()

