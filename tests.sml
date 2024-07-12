

fun g_headers text = convert (explode text) 
fun headers text = implode(g_headers text)

val et = (headers "" = "")
val ht1 = (headers "\n# title\n##t2 \n### title3 \n####### title7\n")
= "\n<h1>title</h1>\n<p>##t2 </p>\n<h3>title3 </h3>\n<p>####### title7\n</p>"
val ht2 = (headers "\n## t2 \n### title3\n") = "\n<h2>t2 </h2>\n<h3>title3</h3>"
val ht3 = (headers "\n###cow \n#1\n") = "\n<p>###cow #1\n</p>"
val ht4 = (headers "\n#### t 4 \n##### f ive\n###### 6\n")
 = "\n<h4>t 4 </h4>\n<h5>f ive</h5>\n<h6>6</h6>"
val ht6 = (headers "\n### #real \n") = "\n<h3>#real </h3>"
val ht7 = (headers "\n##### \n") = "\n<h5></h5>"
val ht8 = (headers "\n# title\n #im #sip that pass out \n## title 2\nua")
 = "\n<h1>title</h1><p> #im #sip that pass out </p>\n<h2>title 2</h2><p>ua</p>"


val l1 = (headers "\n- yeah\n- this is a list \n")
    = "<ul><li>yeah</li><li>this is a list </li></ul>"
val l2 = (headers "\n- carrit\n- gar lick \n- asparigus")
    = "<ul><li>carrit</li><li>gar lick </li><li>asparigus</li></ul>"
val l3 = (headers "\n- c\n- g e \n- as\n-wom \n- gri")
    = "<ul><li>c</li><li>g e </li><li>as</li></ul>-wom <ul><li>gri</li></ul>"
val l4 = (headers "\n- frog") = "<ul><li>frog</li></ul>"
val l5 = (headers "\n- c\n- g e \n- as\n this is now just a p") =
    "<ul><li>c</li><li>g e </li><li>as</li></ul> this is now just a p"

val h1 = (headers "\n--- ") = "<hr>"
val h2 = (headers "\n-- --- --- \n---------- \n owo")
    = "<p>-- --- --- </p><hr><p> owo</p>"
val h3 = (headers "\ngamin ---\n gamin---\n--")
    = "<p>gamin --- gamin-----</p>"
val h4 = (headers "\n-- \n---\n-- \n \n----- \n --- \n-")
    = "<p>-- -----  </p><hr><p> --- -</p>" 

val p1 = (headers "\n got some real stuf thsta got some real\nthings in it #very\n\n good for you")
= "<p> got some real stuf thsta got some realthings in it #very</p><p> good for you</p>"
val p2 = (headers "\n") = ""
val p3 = (headers "\n\n") = "<p>\n</p>"
