

fun g_headers text = he (extract_header_text, explode text) 
fun headers text = implode(g_headers text)

val ht1 = (headers "\n# title\n##t2 \n### title3 \n####### title7\n")
 = "\n<h1>title</h1>\n##t2 \n<h3>title3 </h3>\n####### title7\n"
val ht2 = (headers "\n## t2 \n### title3\n") = "\n<h2>t2 </h2>\n<h3>title3</h3>\n"
val ht3 = (headers "\n###cow \n#1\n") = "\n###cow \n#1\n"
val ht4 = (headers "\n#### t 4 \n##### f ive\n###### 6\n")
    = "\n<h4>t 4 </h4>\n<h5>f ive</h5>\n<h6>6</h6>\n"
val ht6 = (headers "\n### #real \n") = "\n<h3>#real </h3>\n"
val ht7 = (headers "\n##### \n") = "\n<h5></h5>\n"
val ht8 = (headers "\n# title\n #im #sippin that mad pass out \n## title 2\nua")
 = "\n<h1>title</h1>\n #im #sippin that mad pass out \n<h2>title 2</h2>\nua"

