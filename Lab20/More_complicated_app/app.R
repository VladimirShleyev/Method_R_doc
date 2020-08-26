library(shiny)


# Определим UI ----
ui <- fluidPage(
  
  
  titlePanel(
    h1('Более сложное приложение')
    ),
  
  sidebarLayout(position = 'right',  # position управляет с какой стороны будет sidebar
    sidebarPanel(
      h2('sidebar панель')
                 ),
    
    mainPanel(
      h2("главная панель"),
              h3("подзаголовок"),
                h4("Здесь можно разместить какой-то текст. 
                   И выровнять его по левому краю", align = 'left'),
      
      p("p создает параграф текста."),
      
      p("Новая p() функция начинает новый параграф. 
       Передайте параметры стиля для целого параграфа", 
        style = "font-family: 'times'; font-si16pt"),
      
      strong("strong() выделит текст жирным."),
      
      em("em() делает текст курсивным."),
      
      br(),
      
      code("code отражает ваш код, как на ПК"),
      
      div("div создает сегменты текста с одинаковым стилевым оформлением. 
          Это произошло благодаря присвоению 'style = color:blue' to div", 
          style = "color:blue"),
      
      br(),
      
      p("span ведет себя как div, но работает вместе",
        span("с группой слов", style = "color:blue"),
        "которые оказываются внутри параграфа."),
      
      img(src = "кодинг.png", height = 96, width = 160)
      
      
    )
  )
)

# 
# shiny function	HTML5 equivalent	creates
# p	<p>	A paragraph of text
# h1	<h1>	A first level header
# h2	<h2>	A second level header
# h3	<h3>	A third level header
# h4	<h4>	A fourth level header
# h5	<h5>	A fifth level header
# h6	<h6>	A sixth level header
# a	<a>	A hyper link
# br	<br>	A line break (e.g. a blank line)
# div	<div>	A division of text with a uniform style
# span	<span>	An in-line division of text with a uniform style
# pre	<pre>	Text ‘as is’ in a fixed width font
# code	<code>	A formatted block of code
# img	<img>	An image
# strong	<strong>	Bold text
# em	<em>	Italicized text
# HTML	 	Directly passes a character string as HTML code


# Определим серверную логику ----
server <- function(input, output) {
  
}

# Запустим приложение ----
shinyApp(ui = ui, server = server)