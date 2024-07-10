val input_text = "\n# title\n #im #sippin that mad pass out \n## title 2 \n ua";

fun count_hashes cs =
    let fun aux ys acc =
        case ys of
             #"#"::ys' => aux ys' (acc+1)
           | #" "::ys' => acc
           | _ => 0
    in
        aux cs 1
    end

fun he (f, cs) =
    case cs of
         #"\n"::(#"#"::rest) => #"\n"::(
             let
                 val level = count_hashes rest
                 val rest' = List.drop(rest, level)
                 val lstr = Int.toString(level)
                 val ot = "<h"^lstr^">"
                 val ct = "</h"^lstr^">"
            in
                if level < 7 andalso level > 0 then f rest' ot ct
                else he (f,#"#"::rest)
             end
        )
       | c::cs' => c::he(f,cs')
       | [] => []

(* returns a header
* o_tag: opening header tag
* c_tag: closing tag
* *)
fun extract_header_text chars o_tag c_tag =
    let fun aux cs =
        case cs of
             #"\n"::cs' => String.explode(c_tag)
                        @ he(extract_header_text,#"\n"::cs')
           | top::cs' => top:: aux cs'
           | [] => []
    in
        String.explode(o_tag) @ aux chars
    end


val process = he (extract_header_text, explode input_text) 

val ps = implode process
