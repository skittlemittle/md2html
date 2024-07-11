(* counts the number of consecutive "target" chars before the
* next "closer" char, if any other char appears before the "closer"
* it returns 0 (even if there are > 0 "target" chars)
*
* cs: char list
* target: character to count
* closer: caharacter to count till
* *)
fun count_char_till cs target closer =
    let fun aux ys acc =
        case ys of
            y::ys' => if y = target
                       then aux ys' (acc+1)
                       else if y = closer
                       then acc
                       else 0
           | _ => 0
    in
        aux cs 1
    end

fun convert chars =
    let fun find cs =
        case cs of
             #"\n"::(#"#"::rest) => #"\n"::(
                 let
                     val level = count_char_till rest #"#" #" "
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
           | #"\n"::(#"-"::rest) => 
                let
                    val dashes = count_char_till rest #"-" #" "
                    val rest' = List.drop(rest, dashes)
                in
                    if dashes > 2
                    then String.explode("<hr>")@ find rest'
                    else #"\n"::(#"-" :: find rest)
                end
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
