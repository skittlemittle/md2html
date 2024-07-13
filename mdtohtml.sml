use "markdown.sml";

fun load_file filename =
    let
        val ins = TextIO.openIn filename
        fun read_all ins =
            case TextIO.inputLine ins of
                 NONE => ""
               | SOME line => line ^ read_all ins
    in
        read_all ins before TextIO.closeIn ins
    end

fun write_file filename content =
    let
        val outs = TextIO.openOut filename
    in
        TextIO.output (outs, content);
        TextIO.closeOut outs
    end

fun t_list text = convert (explode text) 
fun html_text text = implode(t_list text)



fun main () =
    let
        val args = CommandLine.arguments ();
        val fname = if List.length args < 1
                    then "md.md"
                    else hd args
        val md = "\n" ^ load_file fname
        val _= print md
        val html = html_text md
    in
        write_file "out.html" html
    end

val _ = main ()
