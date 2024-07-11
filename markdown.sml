
fun count_hashes cs =
    let fun aux ys acc =
        case ys of
             #"#"::ys' => aux ys' (acc+1)
           | #" "::ys' => acc
           | _ => 0
    in
        aux cs 1
    end

fun convert chars =
    let fun find cs =
        case cs of
             #"\n"::(#"#"::rest) => #"\n"::(
                 let
                     val level = count_hashes rest
                     val rest' = List.drop(rest, level)
                     val lstr = Int.toString(level)
                     val ot = "<h"^lstr^">"
                     val ct = "</h"^lstr^">"
                in
                    if level < 7 andalso level > 0
                    then extract_header_text rest' ot ct
                    else find (#"#"::rest)
                 end
            )
           | #"\n"::(#"-"::(#" "::rest)) => extract_list rest
           | c::cs' => c::find cs'
           | [] => []

        (* returns a header
        * cs:  text to begin putting in the header
        * o_tag: opening header tag
        * c_tag: closing tag
        * *)
        and extract_header_text cs o_tag c_tag =
            let fun aux ys =
                case ys of
                     #"\n"::ys' => String.explode(c_tag)
                                @ find(#"\n"::ys')
                   | top::ys' => top:: aux ys'
                   | [] => []
            in
                String.explode(o_tag) @ aux cs
            end

        (*returns a list*)
        and extract_list cs =
            let 
                val o_tag = String.explode("<li>")
                val c_tag = String.explode("</li>")
                val n_tag = c_tag @ o_tag 
                val opener = String.explode("<ul>") @ o_tag
                val closer = c_tag @ String.explode("</ul>")
                fun aux ys =
                    case ys of
                         #"\n"::(#"-"::(#" "::rest)) => n_tag @ aux rest
                       | #"\n"::rest => closer @ find rest
                       | y::ys' => y::aux ys'
                       | [] => closer
            in
                opener @ aux cs
            end
    in
        find chars
    end
