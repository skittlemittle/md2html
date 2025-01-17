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

(*are the next chars the beginning of:
* a header
* a list
* an <hr>
* a new paragraph
* *)
fun is_starter cs =
    let
        fun level cs' c = count_char_till cs' c #" "
    in
    case cs of
         #"-"::(#" "::rest) => true
       | #"-"::rest => (level rest #"-") > 2
       | #"#"::rest => (level rest #"#") < 7 andalso (level rest #"#") > 0
       | #"\n"::rest => true
       | _ => false
    end

(* returns true if tag occurs before a \n or string end
* false otherwise *)
fun is_matched cs tag =
    case cs of
         c::cs' => 
            if c = tag andalso c <> #"\n"
            then true
            else is_matched cs' tag
       | [] => false


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
                    else extract_p (#"#"::rest) false
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
                    else extract_p (#"-"::rest) false
                end
           | #"\n"::(#"`"::(#"`"::(#"`"::rest))) => extract_fenced_code rest
           | #"\n"::rest => extract_p rest false
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

        (*returns a paragraph
        * continue: is this a continuation of a paragraph or
        *           the start of a new one?
        * *)
        and extract_p cs continue =
            let 
                val p_c = String.explode("</p>")
                fun aux ys = case ys of
                     #"\n"::(y::ys') =>
                        if is_starter (y::ys')
                        then p_c @ find (#"\n"::(y::ys'))
                        else aux (y::ys')
                   | y::ys' => (case y::ys' of
                         #"*"::(#"*"::(r::j)) => extract_bold (r::j)
                       | #"*"::r => extract_em r
                       | #"`"::r => extract_inline_code r
                       | #"["::r => extract_link r
                       | _ => y::aux ys')
                   | [] => p_c
            in
                if cs = [] then (if continue then p_c else [])
                else if not continue then String.explode("<p>") @ aux cs
                      else aux cs
            end

        and extract_bold cs =
            let fun aux ys = case ys of
                 #"*"::(#"*"::rest) =>
                    (String.explode("</b>") @ extract_p rest true)
               | y::ys' => y::aux ys'
               | [] => String.explode("</b>") @ extract_p [] true
            in
                String.explode("<b>") @ aux cs
            end

        and extract_em cs =
            extract_pair_tag cs #"*" "<em>" "</em>"

        and extract_inline_code cs =
            extract_pair_tag cs #"`" "<code>" "</code>"

        (* extracts paired tags like `code` and *italics*
        * tag: the tag char
        * opener: html opening tag
        * closer: html closing tag
        * *)
        and extract_pair_tag cs tag opener closer =
            let fun aux ys = case ys of
                 y::ys' =>
                       if y = tag
                       then String.explode(closer) @ extract_p ys' true
                       else y::aux ys'
               | [] => String.explode(closer) @ extract_p [] true
            in
                String.explode(opener) @ aux cs
            end

        and extract_fenced_code cs =
            let
                val o_t = String.explode("<pre><code>")
                val c_t = String.explode("</code></pre>")
                fun aux ys =
                    case ys of
                         #"`"::(#"`"::(#"`"::r)) => c_t @ find r
                       | y::ys' => y::aux ys'
                       | [] => c_t
            in
                o_t @ aux cs
            end

        and extract_link cs =
            let fun extract_text ys s =
                    if length ys > 1 andalso hd ys <> s
                    then (hd ys)::extract_text (tl ys) s
                    else []

                fun aux ys acc =
                    let fun a2 zs = extract_text zs #")"
                    in
                        case ys of
                             #"]"::(#"("::ys') =>
                                if is_matched ys' #")"
                                then (#1 acc, a2 ys')
                                else acc
                           | y::ys' => aux ys' ((#1 acc) @ [y], [])
                           | [] => acc
                    end

                val link_content = if is_matched cs #"]"
                                   then aux cs ([],[])
                                   else ([],[])
                val lc_length = length(#1 link_content) + length (#2 link_content)
                val cont = List.drop(cs, lc_length +
                        (if length cs >= lc_length + 3 then 3 else 0))
            in
                if #1 link_content <> [] andalso #2 link_content <> []
                then String.explode("<a href='")
                    @ #2 link_content
                    @ String.explode("'>") 
                    @ #1 link_content
                    @ String.explode("</a>")
                    @ extract_p cont true
                else extract_p cs true
            end

    in
        find chars
    end
