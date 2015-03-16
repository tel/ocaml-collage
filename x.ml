
type value =
  | String of string
  | Int    of int
  | Float  of float
  | Bool   of bool

let string_of_value = function
  | String s -> s
  | Int i    -> string_of_int i
  | Float f  -> string_of_float f
  | Bool b   -> string_of_bool b

type dim =
  [ `em
  | `ex
  | `pct
  | `px
  | `cm
  | `mm
  | `inch
  | `pt
  | `pc
  | `none
  ]

let string_of_dim = function
  | `em -> "em"
  | `ex -> "ex"
  | `pct -> "pct"
  | `px -> "px"
  | `cm -> "cm"
  | `mm -> "mm"
  | `inch -> "in"
  | `pt -> "pt"
  | `pc -> "pc"
  | `none -> ""

module StringLike = struct
  module type S = sig
    type t
    val compare : t -> t -> int
    val of_string : string -> t
    val to_string : t -> string
  end

  module Simple : S = struct
    include String
    let of_string s = s
    let to_string s = s
  end
end

module type Dom = sig

  module Attr : StringLike.S
  module Attrs : Map.S with type key = Attr.t

  module Style : StringLike.S
  module Styles : Map.S with type key = Style.t

  module Tag : StringLike.S

  type t

  val text : string -> t
  val node
    :  Tag.t
    -> value Attrs.t
    -> (value * dim) Styles.t
    -> t list
    -> t

end

module Dom = struct

  module Attr = StringLike.Simple
  module Attrs = Map.Make (Attr)

  module Style = StringLike.Simple
  module Styles = Map.Make (Style)

  module Tag = struct
    type t = string
    let of_string s = String.uppercase s
    let to_string s = s
    let compare = String.compare
  end

  type t =
    | El   of el
    | Text of string
  and el =
    { tag : Tag.t
    ; attrs : value Attrs.t
    ; styles : (value * dim) Styles.t
    ; children : t array
    }

  let text s = Text s
  let node tag attrs styles children =
    El { tag; attrs; styles; children = Array.of_list children }

  let styles_buf : (value * dim) Styles.t -> Buffer.t =
    fun s ->
      let buf = Buffer.create 16 in
      let ( -- ) = Buffer.add_string in
      Styles.iter begin fun prop (value, dim) ->
        buf -- Style.to_string prop;
        buf -- ":";
        buf -- string_of_value value;
        buf -- string_of_dim   dim;
        buf -- ";"
      end s;
      buf

  let attrs_buf : value Attrs.t -> Buffer.t =
    fun ats ->
      let buf = Buffer.create 16 in
      let ( -- ) = Buffer.add_string in
      Attrs.iter begin fun key value ->
        buf -- Attr.to_string key;
        buf -- "=\"";
        buf -- string_of_value value;
        buf -- "\" ";
      end ats;
      buf

  let rec to_string (x : t) : string =
    let buf = Buffer.create 16 in
    let ( -- ) buf s = Buffer.add_string buf s in
    let ( -* ) buf s = Buffer.add_buffer buf s in
    let rec aux : t -> unit =
      function
      | Text s -> buf -- s
      | El { tag; attrs; styles; children } ->
        let stylesb = styles_buf styles in
        let attrs =
          if Styles.is_empty styles then attrs
          else Attrs.add (Attr.of_string "style")
              (String (Buffer.contents stylesb)) attrs in
        buf -- "<";
        buf -- Tag.to_string tag;
        buf -- " ";
        buf -* attrs_buf attrs;
        buf -- ">";
        Array.iter aux children;
        buf -- "</";
        buf -- Tag.to_string tag;
        buf -- ">";
    in
    aux x; Buffer.contents buf

    (*   function *)
    (* | Text s -> s *)
    (* | El { tag; attrs; styles; children } -> *)
    (*   let tg = Tag.to_string tag in *)
    (*   let cs = Array.map to_string children in *)
    (*   let ss = Styles.fold begin fun prop (value, dim) str -> *)
    (*       str ^ *)
    (*       Style.to_string prop *)
    (*       ^ ":" ^ *)
    (*       string_of_value value *)
    (*       ^ ";" ^ *)
    (*       string_of_dim dim *)
    (*     end styles "" in *)
    (*   let attrs = Attrs.fold begin fun at value str -> *)
    (*       str ^ *)
    (*       Attr.to_string at *)
    (*       ^ "=\"" ^ *)
    (*       string_of_value value *)
    (*       ^ "\" " *)
    (*     end (Attrs.add (Attr.of_string "style") (String ss) attrs) "" in *)
    (*   "<" ^ tg ^ " " ^ attrs ^ begin *)
    (*     if Array.length cs = 0 then "/>" *)
    (*     else *)
    (*       let inner = Array.fold_left (fun str c -> str ^ c) "" cs in *)
    (*       ">" ^ inner ^ "<" ^ tg ^ ">" *)
    (*   end *)

end

module type DSL = sig
  include Dom

  module C : sig

    type node_c =
         ?attrs  : (Attr.t  * value)       list
      -> ?styles : (Style.t * value * dim) list
      -> t list
      -> t

    type leaf_c =
         ?attrs  : (Attr.t  * value)       list
      -> ?styles : (Style.t * value * dim) list
      -> unit
      -> t

    module El : sig
      val a_          : node_c
      val abbr_       : node_c
      val address_    : node_c
      val area_       : leaf_c
      val article_    : node_c
      val aside_      : node_c
      val audio_      : node_c
      val b_          : node_c
      val base_       : leaf_c
      val bdo_        : node_c
      val blockquote_ : node_c
      val body_       : node_c
      val br_         : leaf_c
      val button_     : node_c
      val canvas_     : node_c
      val caption_    : node_c
      val cite_       : node_c
      val code_       : node_c
      val col_        : leaf_c
      val colgroup_   : node_c
      val command_    : node_c
      val datalist_   : node_c
      val dd_         : node_c
      val del_        : node_c
      val details_    : node_c
      val dfn_        : node_c
      val div_        : node_c
      val dl_         : node_c
      val dt_         : node_c
      val em_         : node_c
      val embed_      : leaf_c
      val fieldset_   : node_c
      val figcaption_ : node_c
      val figure_     : node_c
      val footer_     : node_c
      val form_       : node_c
      val h1_         : node_c
      val h2_         : node_c
      val h3_         : node_c
      val h4_         : node_c
      val h5_         : node_c
      val h6_         : node_c
      val head_       : node_c
      val header_     : node_c
      val hgroup_     : node_c
      val hr_         : leaf_c
      val html_       : node_c
      val i_          : node_c
      val iframe_     : node_c
      val img_        : leaf_c
      val input_      : leaf_c
      val ins_        : node_c
      val kbd_        : node_c
      val keygen_     : leaf_c
      val label_      : node_c
      val legend_     : node_c
      val li_         : node_c
      val link_       : leaf_c
      val map_        : node_c
      val main_       : node_c
      val mark_       : node_c
      val menu_       : node_c
      val menuitem_   : leaf_c
      val meta_       : leaf_c
      val meter_      : node_c
      val nav_        : node_c
      val noscript_   : node_c
      val object_     : node_c
      val ol_         : node_c
      val optgroup_   : node_c
      val option_     : node_c
      val output_     : node_c
      val p_          : node_c
      val param_      : leaf_c
      val svg_        : node_c
      val pre_        : node_c
      val progress_   : node_c
      val q_          : node_c
      val rp_         : node_c
      val rt_         : node_c
      val ruby_       : node_c
      val samp_       : node_c
      val script_     : node_c
      val section_    : node_c
      val select_     : node_c
      val small_      : node_c
      val source_     : leaf_c
      val span_       : node_c
      val strong_     : node_c
      val style_      : node_c    (* element and attribute *)
      val sub_        : node_c
      val summary_    : node_c
      val sup_        : node_c
      val table_      : node_c
      val tbody_      : node_c
      val td_         : node_c
      val textarea_   : node_c
      val tfoot_      : node_c
      val th_         : node_c
      val template_   : node_c
      val thead_      : node_c
      val time_       : node_c
      val title_      : node_c    (* element and attribute *)
      val tr_         : node_c
      val track_      : leaf_c
      val ul_         : node_c
      val var_        : node_c
      val video_      : node_c
      val wbr_        : leaf_c
    end

    module At : sig
      val accept_             : Attr.t
      val accept_charset_     : Attr.t
      val accesskey_          : Attr.t
      val action_             : Attr.t
      val alt_                : Attr.t
      val async_              : Attr.t
      val autocomplete_       : Attr.t
      val autofocus_          : Attr.t
      val autoplay_           : Attr.t
      val challenge_          : Attr.t
      val charset_            : Attr.t
      val checked_            : Attr.t
      val cite_               : Attr.t
      val class_              : Attr.t
      val cols_               : Attr.t
      val colspan_            : Attr.t
      val content_            : Attr.t
      val contenteditable_    : Attr.t
      val contextmenu_        : Attr.t
      val controls_           : Attr.t
      val coords_             : Attr.t
      val data_               : Attr.t
      val datetime_           : Attr.t
      val defer_              : Attr.t
      val dir_                : Attr.t
      val disabled_           : Attr.t
      val draggable_          : Attr.t
      val enctype_            : Attr.t
      val for_                : Attr.t
      val form_               : Attr.t
      val formaction_         : Attr.t
      val formenctype_        : Attr.t
      val formmethod_         : Attr.t
      val formnovalidate_     : Attr.t
      val formtarget_         : Attr.t
      val headers_            : Attr.t
      val height_             : Attr.t
      val hidden_             : Attr.t
      val high_               : Attr.t
      val href_               : Attr.t
      val hreflang_           : Attr.t
      val httpEquiv_          : Attr.t
      val icon_               : Attr.t
      val id_                 : Attr.t
      val ismap_              : Attr.t
      val item_               : Attr.t
      val itemprop_           : Attr.t
      val keytype_            : Attr.t
      val label_              : Attr.t
      val lang_               : Attr.t
      val list_               : Attr.t
      val loop_               : Attr.t
      val low_                : Attr.t
      val manifest_           : Attr.t
      val max_                : Attr.t
      val maxlength_          : Attr.t
      val media_              : Attr.t
      val method_             : Attr.t
      val min_                : Attr.t
      val multiple_           : Attr.t
      val name_               : Attr.t
      val novalidate_         : Attr.t
      val onbeforeonload_     : Attr.t
      val onbeforeprint_      : Attr.t
      val onblur_             : Attr.t
      val oncanplay_          : Attr.t
      val oncanplaythrough_   : Attr.t
      val onchange_           : Attr.t
      val onclick_            : Attr.t
      val oncontextmenu_      : Attr.t
      val ondblclick_         : Attr.t
      val ondrag_             : Attr.t
      val ondragend_          : Attr.t
      val ondragenter_        : Attr.t
      val ondragleave_        : Attr.t
      val ondragover_         : Attr.t
      val ondragstart_        : Attr.t
      val ondrop_             : Attr.t
      val ondurationchange_   : Attr.t
      val onemptied_          : Attr.t
      val onended_            : Attr.t
      val onerror_            : Attr.t
      val onfocus_            : Attr.t
      val onformchange_       : Attr.t
      val onforminput_        : Attr.t
      val onhaschange_        : Attr.t
      val oninput_            : Attr.t
      val oninvalid_          : Attr.t
      val onkeydown_          : Attr.t
      val onkeyup_            : Attr.t
      val onload_             : Attr.t
      val onloadeddata_       : Attr.t
      val onloadedmetadata_   : Attr.t
      val onloadstart_        : Attr.t
      val onmessage_          : Attr.t
      val onmousedown_        : Attr.t
      val onmousemove_        : Attr.t
      val onmouseout_         : Attr.t
      val onmouseover_        : Attr.t
      val onmouseup_          : Attr.t
      val onmousewheel_       : Attr.t
      val ononline_           : Attr.t
      val onpagehide_         : Attr.t
      val onpageshow_         : Attr.t
      val onpause_            : Attr.t
      val onplay_             : Attr.t
      val onplaying_          : Attr.t
      val onprogress_         : Attr.t
      val onpropstate_        : Attr.t
      val onratechange_       : Attr.t
      val onreadystatechange_ : Attr.t
      val onredo_             : Attr.t
      val onresize_           : Attr.t
      val onscroll_           : Attr.t
      val onseeked_           : Attr.t
      val onseeking_          : Attr.t
      val onselect_           : Attr.t
      val onstalled_          : Attr.t
      val onstorage_          : Attr.t
      val onsubmit_           : Attr.t
      val onsuspend_          : Attr.t
      val ontimeupdate_       : Attr.t
      val onundo_             : Attr.t
      val onunload_           : Attr.t
      val onvolumechange_     : Attr.t
      val onwaiting_          : Attr.t
      val open_               : Attr.t
      val optimum_            : Attr.t
      val pattern_            : Attr.t
      val ping_               : Attr.t
      val placeholder_        : Attr.t
      val preload_            : Attr.t
      val pubdate_            : Attr.t
      val radiogroup_         : Attr.t
      val readonly_           : Attr.t
      val rel_                : Attr.t
      val required_           : Attr.t
      val reversed_           : Attr.t
      val rows_               : Attr.t
      val rowspan_            : Attr.t
      val sandbox_            : Attr.t
      val scope_              : Attr.t
      val scoped_             : Attr.t
      val seamless_           : Attr.t
      val selected_           : Attr.t
      val shape_              : Attr.t
      val size_               : Attr.t
      val sizes_              : Attr.t
      val span_               : Attr.t
      val spellcheck_         : Attr.t
      val src_                : Attr.t
      val srcdoc_             : Attr.t
      val start_              : Attr.t
      val step_               : Attr.t
      val style_              : Attr.t
      val subject_            : Attr.t
      val summary_            : Attr.t
      val tabindex_           : Attr.t
      val target_             : Attr.t
      val title_              : Attr.t
      val type_               : Attr.t
      val usemap_             : Attr.t
      val value_              : Attr.t
      val width_              : Attr.t
      val wrap_               : Attr.t
      val xmlns_              : Attr.t
    end

    (** http://htmldog.com/reference/cssproperties/ *)
    module Sty : sig

      val font_                  : Style.t
      val font_family_           : Style.t
      val font_size_             : Style.t
      val font_weight_           : Style.t
      val font_style_            : Style.t
      val font_variant_          : Style.t
      val line_height_           : Style.t
      val letter_spacing_        : Style.t
      val word_spacing_          : Style.t
      val text_align_            : Style.t
      val text_decoration_       : Style.t
      val text_indent_           : Style.t
      val text_transform_        : Style.t
      val vertical_align_        : Style.t
      val white_space_           : Style.t

      val color_                 : Style.t
      val background_color_      : Style.t
      val background_            : Style.t
      val background_image_      : Style.t
      val background_repeat_     : Style.t
      val background_position_   : Style.t
      val background_attachment_ : Style.t

      val padding_               : Style.t
      val padding_top_           : Style.t
      val padding_right_         : Style.t
      val padding_bottom_        : Style.t
      val padding_left_          : Style.t
      val border_                : Style.t
      val border_top_            : Style.t
      val border_right_          : Style.t
      val border_bottom_         : Style.t
      val border_left_           : Style.t
      val border_style_          : Style.t
      val border_top_style_      : Style.t
      val border_right_style_    : Style.t
      val border_bottom_style_   : Style.t
      val border_left_style_     : Style.t
      val border_color_          : Style.t
      val border_top_color_      : Style.t
      val border_right_color_    : Style.t
      val border_bottom_color_   : Style.t
      val border_left_color_     : Style.t
      val border_width_          : Style.t
      val border_top_width_      : Style.t
      val border_right_width_    : Style.t
      val border_bottom_width_   : Style.t
      val border_left_width_     : Style.t
      val outline_               : Style.t
      val outline_style_         : Style.t
      val outline_color_         : Style.t
      val outline_width_         : Style.t
      val margin_                : Style.t
      val margin_top_            : Style.t
      val margin_right_          : Style.t
      val margin_bottom_         : Style.t
      val margin_left_           : Style.t
      val width_                 : Style.t
      val height_                : Style.t
      val min_width_             : Style.t
      val max_width_             : Style.t
      val min_height_            : Style.t
      val max_height_            : Style.t

      val position_              : Style.t
      val top_                   : Style.t
      val right_                 : Style.t
      val bottom_                : Style.t
      val left_                  : Style.t
      val clip_                  : Style.t
      val overflow_              : Style.t
      val z_index_               : Style.t
      val float_                 : Style.t
      val clear_                 : Style.t
      val display_               : Style.t
      val visibility_            : Style.t

      val list_style_            : Style.t
      val list_style_type_       : Style.t
      val list_style_image_      : Style.t
      val list_style_position_   : Style.t

      val table_layout_          : Style.t
      val border_collapse_       : Style.t
      val border_spacing_        : Style.t
      val empty_cells_           : Style.t
      val caption_side_          : Style.t

      val content_               : Style.t
      val counter_increment      : Style.t
      val counter_reset_         : Style.t
      val quotes_                : Style.t

      val page_break_before_     : Style.t
      val page_break_after_      : Style.t
      val page_break_inside_     : Style.t
      val orphans_               : Style.t
      val widows_                : Style.t

      val cursor_                : Style.t
      val direction_             : Style.t
      val unicode_bidi_          : Style.t

    end
  end
end

module DSL_Of (Dom : Dom) : DSL
  with type t = Dom.t
   and module Attr  = Dom.Attr
   and module Style = Dom.Style
= struct

  include Dom

  module C = struct

    type node_c =
         ?attrs  : (Attr.t  * value)       list
      -> ?styles : (Style.t * value * dim) list
      -> t list
      -> t

    type leaf_c =
         ?attrs  : (Attr.t  * value)       list
      -> ?styles : (Style.t * value * dim) list
      -> unit
      -> t

    let mk_attrs : (Attr.t * value) list -> value Attrs.t =
      List.fold_left
        (fun atts (prop, value) -> Attrs.add prop value atts)
        Attrs.empty

    let mk_styles : (Style.t * value * dim) list -> (value * dim) Styles.t =
      List.fold_left
        (fun atts (prop, value, dim) -> Styles.add prop (value, dim) atts)
        Styles.empty

    let mk_node : string -> node_c =
      fun
        tag
        ?attrs:(attrs = [])
        ?styles:(styles = [])
        children ->
        Dom.node
          (Tag.of_string tag)
          (mk_attrs attrs)
          (mk_styles styles)
          children

    let mk_leaf : string -> leaf_c =
      fun
        tag
        ?attrs:(attrs = [])
        ?styles:(styles = [])
        () ->
        Dom.node
          (Tag.of_string tag)
          (mk_attrs attrs)
          (mk_styles styles)
          []

    module El = struct
      let a_ = mk_node "a"
      let abbr_ = mk_node "abbr"
      let address_ = mk_node "address"
      let area_ = mk_leaf "area"
      let article_ = mk_node "article"
      let aside_ = mk_node "aside"
      let audio_ = mk_node "audio"
      let b_ = mk_node "b"
      let base_ = mk_leaf "base"
      let bdo_ = mk_node "bdo"
      let blockquote_ = mk_node "blockquote"
      let body_ = mk_node "body"
      let br_ = mk_leaf "br"
      let button_ = mk_node "button"
      let canvas_ = mk_node "canvas"
      let caption_ = mk_node "caption"
      let cite_ = mk_node "cite"
      let code_ = mk_node "code"
      let col_ = mk_leaf "col"
      let colgroup_ = mk_node "colgroup"
      let command_ = mk_node "command"
      let datalist_ = mk_node "datalist"
      let dd_ = mk_node "dd"
      let del_ = mk_node "del"
      let details_ = mk_node "details"
      let dfn_ = mk_node "dfn"
      let div_ = mk_node "div"
      let dl_ = mk_node "dl"
      let dt_ = mk_node "dt"
      let em_ = mk_node "em"
      let embed_ = mk_leaf "embed"
      let fieldset_ = mk_node "fieldset"
      let figcaption_ = mk_node "figcaption"
      let figure_ = mk_node "figure"
      let footer_ = mk_node "footer"
      let form_ = mk_node "form"
      let h1_ = mk_node "h1"
      let h2_ = mk_node "h2"
      let h3_ = mk_node "h3"
      let h4_ = mk_node "h4"
      let h5_ = mk_node "h5"
      let h6_ = mk_node "h6"
      let head_ = mk_node "head"
      let header_ = mk_node "header"
      let hgroup_ = mk_node "hgroup"
      let hr_ = mk_leaf "hr"
      let html_ = mk_node "html"
      let i_ = mk_node "i"
      let iframe_ = mk_node "iframe"
      let img_ = mk_leaf "img"
      let input_ = mk_leaf "input"
      let ins_ = mk_node "ins"
      let kbd_ = mk_node "kbd"
      let keygen_ = mk_leaf "keygen"
      let label_ = mk_node "label"
      let legend_ = mk_node "legend"
      let li_ = mk_node "li"
      let link_ = mk_leaf "link"
      let map_ = mk_node "map"
      let main_ = mk_node "main"
      let mark_ = mk_node "mark"
      let menu_ = mk_node "menu"
      let menuitem_ = mk_leaf "menuitem"
      let meta_ = mk_leaf "meta"
      let meter_ = mk_node "meter"
      let nav_ = mk_node "nav"
      let noscript_ = mk_node "noscript"
      let object_ = mk_node "object"
      let ol_ = mk_node "ol"
      let optgroup_ = mk_node "optgroup"
      let option_ = mk_node "option"
      let output_ = mk_node "output"
      let p_ = mk_node "p"
      let param_ = mk_leaf "param"
      let svg_ = mk_node "svg"
      let pre_ = mk_node "pre"
      let progress_ = mk_node "progress"
      let q_ = mk_node "q"
      let rp_ = mk_node "rp"
      let rt_ = mk_node "rt"
      let ruby_ = mk_node "ruby"
      let samp_ = mk_node "samp"
      let script_ = mk_node "script"
      let section_ = mk_node "section"
      let select_ = mk_node "select"
      let small_ = mk_node "small"
      let source_ = mk_leaf "source"
      let span_ = mk_node "span"
      let strong_ = mk_node "strong"
      let style_ = mk_node "style"
      let sub_ = mk_node "sub"
      let summary_ = mk_node "summary"
      let sup_ = mk_node "sup"
      let table_ = mk_node "table"
      let tbody_ = mk_node "tbody"
      let td_ = mk_node "td"
      let textarea_ = mk_node "textarea"
      let tfoot_ = mk_node "tfoot"
      let th_ = mk_node "th"
      let template_ = mk_node "template"
      let thead_ = mk_node "thead"
      let time_ = mk_node "time"
      let title_ = mk_node "title"
      let tr_ = mk_node "tr"
      let track_ = mk_leaf "track"
      let ul_ = mk_node "ul"
      let var_ = mk_node "var"
      let video_ = mk_node "video"
      let wbr_ = mk_leaf "wbr"
    end

    module At = struct
      let accept_ = Attr.of_string "accept"
      let accept_charset_ = Attr.of_string "accept-charset"
      let accesskey_ = Attr.of_string "accesskey"
      let action_ = Attr.of_string "action"
      let alt_ = Attr.of_string "alt"
      let async_ = Attr.of_string "async"
      let autocomplete_ = Attr.of_string "autocomplete"
      let autofocus_ = Attr.of_string "autofocus"
      let autoplay_ = Attr.of_string "autoplay"
      let challenge_ = Attr.of_string "challenge"
      let charset_ = Attr.of_string "charset"
      let checked_ = Attr.of_string "checked"
      let cite_ = Attr.of_string "cite"
      let class_ = Attr.of_string "class"
      let cols_ = Attr.of_string "cols"
      let colspan_ = Attr.of_string "colspan"
      let content_ = Attr.of_string "content"
      let contenteditable_ = Attr.of_string "contenteditable"
      let contextmenu_ = Attr.of_string "contextmenu"
      let controls_ = Attr.of_string "controls"
      let coords_ = Attr.of_string "coords"
      let data_ = Attr.of_string "data"
      let datetime_ = Attr.of_string "datetime"
      let defer_ = Attr.of_string "defer"
      let dir_ = Attr.of_string "dir"
      let disabled_ = Attr.of_string "disabled"
      let draggable_ = Attr.of_string "draggable"
      let enctype_ = Attr.of_string "enctype"
      let for_ = Attr.of_string "for"
      let form_ = Attr.of_string "form"
      let formaction_ = Attr.of_string "formaction"
      let formenctype_ = Attr.of_string "formenctype"
      let formmethod_ = Attr.of_string "formmethod"
      let formnovalidate_ = Attr.of_string "formnovalidate"
      let formtarget_ = Attr.of_string "formtarget"
      let headers_ = Attr.of_string "headers"
      let height_ = Attr.of_string "height"
      let hidden_ = Attr.of_string "hidden"
      let high_ = Attr.of_string "high"
      let href_ = Attr.of_string "href"
      let hreflang_ = Attr.of_string "hreflang"
      let httpEquiv_ = Attr.of_string "httpEquiv"
      let icon_ = Attr.of_string "icon"
      let id_ = Attr.of_string "id"
      let ismap_ = Attr.of_string "ismap"
      let item_ = Attr.of_string "item"
      let itemprop_ = Attr.of_string "itemprop"
      let keytype_ = Attr.of_string "keytype"
      let label_ = Attr.of_string "label"
      let lang_ = Attr.of_string "lang"
      let list_ = Attr.of_string "list"
      let loop_ = Attr.of_string "loop"
      let low_ = Attr.of_string "low"
      let manifest_ = Attr.of_string "manifest"
      let max_ = Attr.of_string "max"
      let maxlength_ = Attr.of_string "maxlength"
      let media_ = Attr.of_string "media"
      let method_ = Attr.of_string "method"
      let min_ = Attr.of_string "min"
      let multiple_ = Attr.of_string "multiple"
      let name_ = Attr.of_string "name"
      let novalidate_ = Attr.of_string "novalidate"
      let onbeforeonload_ = Attr.of_string "onbeforeonload"
      let onbeforeprint_ = Attr.of_string "onbeforeprint"
      let onblur_ = Attr.of_string "onblur"
      let oncanplay_ = Attr.of_string "oncanplay"
      let oncanplaythrough_ = Attr.of_string "oncanplaythrough"
      let onchange_ = Attr.of_string "onchange"
      let onclick_ = Attr.of_string "onclick"
      let oncontextmenu_ = Attr.of_string "oncontextmenu"
      let ondblclick_ = Attr.of_string "ondblclick"
      let ondrag_ = Attr.of_string "ondrag"
      let ondragend_ = Attr.of_string "ondragend"
      let ondragenter_ = Attr.of_string "ondragenter"
      let ondragleave_ = Attr.of_string "ondragleave"
      let ondragover_ = Attr.of_string "ondragover"
      let ondragstart_ = Attr.of_string "ondragstart"
      let ondrop_ = Attr.of_string "ondrop"
      let ondurationchange_ = Attr.of_string "ondurationchange"
      let onemptied_ = Attr.of_string "onemptied"
      let onended_ = Attr.of_string "onended"
      let onerror_ = Attr.of_string "onerror"
      let onfocus_ = Attr.of_string "onfocus"
      let onformchange_ = Attr.of_string "onformchange"
      let onforminput_ = Attr.of_string "onforminput"
      let onhaschange_ = Attr.of_string "onhaschange"
      let oninput_ = Attr.of_string "oninput"
      let oninvalid_ = Attr.of_string "oninvalid"
      let onkeydown_ = Attr.of_string "onkeydown"
      let onkeyup_ = Attr.of_string "onkeyup"
      let onload_ = Attr.of_string "onload"
      let onloadeddata_ = Attr.of_string "onloadeddata"
      let onloadedmetadata_ = Attr.of_string "onloadedmetadata"
      let onloadstart_ = Attr.of_string "onloadstart"
      let onmessage_ = Attr.of_string "onmessage"
      let onmousedown_ = Attr.of_string "onmousedown"
      let onmousemove_ = Attr.of_string "onmousemove"
      let onmouseout_ = Attr.of_string "onmouseout"
      let onmouseover_ = Attr.of_string "onmouseover"
      let onmouseup_ = Attr.of_string "onmouseup"
      let onmousewheel_ = Attr.of_string "onmousewheel"
      let ononline_ = Attr.of_string "ononline"
      let onpagehide_ = Attr.of_string "onpagehide"
      let onpageshow_ = Attr.of_string "onpageshow"
      let onpause_ = Attr.of_string "onpause"
      let onplay_ = Attr.of_string "onplay"
      let onplaying_ = Attr.of_string "onplaying"
      let onprogress_ = Attr.of_string "onprogress"
      let onpropstate_ = Attr.of_string "onpropstate"
      let onratechange_ = Attr.of_string "onratechange"
      let onreadystatechange_ = Attr.of_string "onreadystatechange"
      let onredo_ = Attr.of_string "onredo"
      let onresize_ = Attr.of_string "onresize"
      let onscroll_ = Attr.of_string "onscroll"
      let onseeked_ = Attr.of_string "onseeked"
      let onseeking_ = Attr.of_string "onseeking"
      let onselect_ = Attr.of_string "onselect"
      let onstalled_ = Attr.of_string "onstalled"
      let onstorage_ = Attr.of_string "onstorage"
      let onsubmit_ = Attr.of_string "onsubmit"
      let onsuspend_ = Attr.of_string "onsuspend"
      let ontimeupdate_ = Attr.of_string "ontimeupdate"
      let onundo_ = Attr.of_string "onundo"
      let onunload_ = Attr.of_string "onunload"
      let onvolumechange_ = Attr.of_string "onvolumechange"
      let onwaiting_ = Attr.of_string "onwaiting"
      let open_ = Attr.of_string "open"
      let optimum_ = Attr.of_string "optimum"
      let pattern_ = Attr.of_string "pattern"
      let ping_ = Attr.of_string "ping"
      let placeholder_ = Attr.of_string "placeholder"
      let preload_ = Attr.of_string "preload"
      let pubdate_ = Attr.of_string "pubdate"
      let radiogroup_ = Attr.of_string "radiogroup"
      let readonly_ = Attr.of_string "readonly"
      let rel_ = Attr.of_string "rel"
      let required_ = Attr.of_string "required"
      let reversed_ = Attr.of_string "reversed"
      let rows_ = Attr.of_string "rows"
      let rowspan_ = Attr.of_string "rowspan"
      let sandbox_ = Attr.of_string "sandbox"
      let scope_ = Attr.of_string "scope"
      let scoped_ = Attr.of_string "scoped"
      let seamless_ = Attr.of_string "seamless"
      let selected_ = Attr.of_string "selected"
      let shape_ = Attr.of_string "shape"
      let size_ = Attr.of_string "size"
      let sizes_ = Attr.of_string "sizes"
      let span_ = Attr.of_string "span"
      let spellcheck_ = Attr.of_string "spellcheck"
      let src_ = Attr.of_string "src"
      let srcdoc_ = Attr.of_string "srcdoc"
      let start_ = Attr.of_string "start"
      let step_ = Attr.of_string "step"
      let style_ = Attr.of_string "style"
      let subject_ = Attr.of_string "subject"
      let summary_ = Attr.of_string "summary"
      let tabindex_ = Attr.of_string "tabindex"
      let target_ = Attr.of_string "target"
      let title_ = Attr.of_string "title"
      let type_ = Attr.of_string "type"
      let usemap_ = Attr.of_string "usemap"
      let value_ = Attr.of_string "value"
      let width_ = Attr.of_string "width"
      let wrap_ = Attr.of_string "wrap"
      let xmlns_ = Attr.of_string "xmlns"
    end

    module Sty = struct

      let font_ = Style.of_string "font"
      let font_family_ = Style.of_string "font-family"
      let font_size_ = Style.of_string "font-size"
      let font_weight_ = Style.of_string "font-weight"
      let font_style_ = Style.of_string "font-style"
      let font_variant_ = Style.of_string "font-variant"
      let line_height_ = Style.of_string "line-height"
      let letter_spacing_ = Style.of_string "letter-spacing"
      let word_spacing_ = Style.of_string "word-spacing"
      let text_align_ = Style.of_string "text-align"
      let text_decoration_ = Style.of_string "text-decoration"
      let text_indent_ = Style.of_string "text-indent"
      let text_transform_ = Style.of_string "text-transform"
      let vertical_align_ = Style.of_string "vertical-align"
      let white_space_ = Style.of_string "white-space"

      let color_ = Style.of_string "color"
      let background_color_ = Style.of_string "background-color"
      let background_ = Style.of_string "background"
      let background_image_ = Style.of_string "background-image"
      let background_repeat_ = Style.of_string "background-repeat"
      let background_position_ = Style.of_string "background-position"
      let background_attachment_ = Style.of_string "background-attachment"

      let padding_ = Style.of_string "padding"
      let padding_top_ = Style.of_string "padding-top"
      let padding_right_ = Style.of_string "padding-right"
      let padding_bottom_ = Style.of_string "padding-bottom"
      let padding_left_ = Style.of_string "padding-left"
      let border_ = Style.of_string "border"
      let border_top_ = Style.of_string "border-top"
      let border_right_ = Style.of_string "border-right"
      let border_bottom_ = Style.of_string "border-bottom"
      let border_left_ = Style.of_string "border-left"
      let border_style_ = Style.of_string "border-style"
      let border_top_style_ = Style.of_string "border-top-style"
      let border_right_style_ = Style.of_string "border-right-style"
      let border_bottom_style_ = Style.of_string "border-bottom-style"
      let border_left_style_ = Style.of_string "border-left-style"
      let border_color_ = Style.of_string "border-color"
      let border_top_color_ = Style.of_string "border-top-color"
      let border_right_color_ = Style.of_string "border-right-color"
      let border_bottom_color_ = Style.of_string "border-bottom-color"
      let border_left_color_ = Style.of_string "border-left-color"
      let border_width_ = Style.of_string "border-width"
      let border_top_width_ = Style.of_string "border-top-width"
      let border_right_width_ = Style.of_string "border-right-width"
      let border_bottom_width_ = Style.of_string "border-bottom-width"
      let border_left_width_ = Style.of_string "border-left-width"
      let outline_ = Style.of_string "outline"
      let outline_style_ = Style.of_string "outline-style"
      let outline_color_ = Style.of_string "outline-color"
      let outline_width_ = Style.of_string "outline-width"
      let margin_ = Style.of_string "margin"
      let margin_top_ = Style.of_string "margin-top"
      let margin_right_ = Style.of_string "margin-right"
      let margin_bottom_ = Style.of_string "margin-bottom"
      let margin_left_ = Style.of_string "margin-left"
      let width_ = Style.of_string "width"
      let height_ = Style.of_string "height"
      let min_width_ = Style.of_string "min-width"
      let max_width_ = Style.of_string "max-width"
      let min_height_ = Style.of_string "min-height"
      let max_height_ = Style.of_string "max-height"

      let position_ = Style.of_string "position"
      let top_ = Style.of_string "top"
      let right_ = Style.of_string "right"
      let bottom_ = Style.of_string "bottom"
      let left_ = Style.of_string "left"
      let clip_ = Style.of_string "clip"
      let overflow_ = Style.of_string "overflow"
      let z_index_ = Style.of_string "z-index"
      let float_ = Style.of_string "float"
      let clear_ = Style.of_string "clear"
      let display_ = Style.of_string "display"
      let visibility_ = Style.of_string "visibility"

      let list_style_ = Style.of_string "list-style"
      let list_style_type_ = Style.of_string "list-style-type"
      let list_style_image_ = Style.of_string "list-style-image"
      let list_style_position_ = Style.of_string "list-style-position"

      let table_layout_ = Style.of_string "table_layout"
      let border_collapse_ = Style.of_string "border-collapse"
      let border_spacing_ = Style.of_string "border-spacing"
      let empty_cells_ = Style.of_string "empty-cells"
      let caption_side_ = Style.of_string "caption-side"

      let content_ = Style.of_string "content"
      let counter_increment = Style.of_string "counter-incremen"
      let counter_reset_ = Style.of_string "counter-reset"
      let quotes_ = Style.of_string "quotes"

      let page_break_before_ = Style.of_string "page-break-before"
      let page_break_after_ = Style.of_string "page-break-after"
      let page_break_inside_ = Style.of_string "page-break-inside"
      let orphans_ = Style.of_string "orphans"
      let widows_ = Style.of_string "widows"

      let cursor_ = Style.of_string "cursor"
      let direction_ = Style.of_string "direction"
      let unicode_bidi_ = Style.of_string "unicode-bidi"

    end

  end
end

module DSL = DSL_Of (Dom)

let q =
  let open DSL.C.Sty in
  let open DSL.C.At in
  let open DSL.C.El in
  let open DSL in
  let ( % ) p v = (DSL.Attr.of_string p, String v) in
  html_ [
    head_ [
      meta_ ~attrs:[
        "author" % "Joseph Abrahamson";
      ] ()
    ];
    body_ [
      div_ [
        text "Hello world!"
      ]
    ]
  ]
