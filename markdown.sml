val input_text = " # title \n im sippin that mad water to pass out \n ## title 2 \n ua";


fun he (f, cs) =
    case cs of
         #"#"::rest => (case rest of
                            #" "::rs' => String.explode("<h1>") @ f rs'
                          | _ => rest)
       | c::cs' => c::he(f,cs')
       | [] => []

fun htext cs =
    case cs of
         #"\n"::cs' => String.explode("</h1>") @ he(htext, cs')
       | top::cs' => top:: htext cs'
       | [] => []


val process = he (htext, explode input_text) 

val ps = implode process
