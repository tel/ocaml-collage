module type S = sig
  type t
  type attr
  module AttrMap : Map.S with type key = string
  type attrs = attr AttrMap.t

  val text : string -> t

  (** Content creation functions, not to be exported into the DSL *)

  val mk_node : name:string -> ?attributes:attrs -> t list -> t
  val mk_leaf : name:string -> ?attributes:attrs -> unit   -> t
  val mk_attr : name:string -> string -> attrs
end

module type DSL = sig

  (** Html5 documents constructed abstractly *)
  type t

  (** Abstract attributes *)
  type attr
  module AttrMap : Map.S with type key = string
  type attrs = attr AttrMap.t

  (** Free text can be inserted into an Html5 document *)
  val text : string -> t

  (************************************************************)

  (** The [El] module contains all of the HTML 5 element
      constructors. *)
  module El : sig

    (** The type of node is a function which constructs a node
        recursively *)
    type mk_node = ?attributes:attrs -> t list -> t

    (** The type of leaf is a function which constructs a node with no
        children *)
    type mk_leaf = ?attributes:attrs -> unit -> t

    val a_          : mk_node
    val abbr_       : mk_node
    val address_    : mk_node
    val area_       : mk_leaf
    val article_    : mk_node
    val aside_      : mk_node
    val audio_      : mk_node
    val b_          : mk_node
    val base_       : mk_leaf
    val bdo_        : mk_node
    val blockquote_ : mk_node
    val body_       : mk_node
    val br_         : mk_leaf
    val button_     : mk_node
    val canvas_     : mk_node
    val caption_    : mk_node
    val cite_       : mk_node
    val code_       : mk_node
    val col_        : mk_leaf
    val colgroup_   : mk_node
    val command_    : mk_node
    val datalist_   : mk_node
    val dd_         : mk_node
    val del_        : mk_node
    val details_    : mk_node
    val dfn_        : mk_node
    val div_        : mk_node
    val dl_         : mk_node
    val dt_         : mk_node
    val em_         : mk_node
    val embed_      : mk_leaf
    val fieldset_   : mk_node
    val figcaption_ : mk_node
    val figure_     : mk_node
    val footer_     : mk_node
    val form_       : mk_node
    val h1_         : mk_node
    val h2_         : mk_node
    val h3_         : mk_node
    val h4_         : mk_node
    val h5_         : mk_node
    val h6_         : mk_node
    val head_       : mk_node
    val header_     : mk_node
    val hgroup_     : mk_node
    val hr_         : mk_leaf
    val html_       : mk_node
    val i_          : mk_node
    val iframe_     : mk_node
    val img_        : mk_leaf
    val input_      : mk_leaf
    val ins_        : mk_node
    val kbd_        : mk_node
    val keygen_     : mk_leaf
    val label_      : mk_node
    val legend_     : mk_node
    val li_         : mk_node
    val link_       : mk_leaf
    val map_        : mk_node
    val main_       : mk_node
    val mark_       : mk_node
    val menu_       : mk_node
    val menuitem_   : mk_leaf
    val meta_       : mk_leaf
    val meter_      : mk_node
    val nav_        : mk_node
    val noscript_   : mk_node
    val object_     : mk_node
    val ol_         : mk_node
    val optgroup_   : mk_node
    val option_     : mk_node
    val output_     : mk_node
    val p_          : mk_node
    val param_      : mk_leaf
    val svg_        : mk_node
    val pre_        : mk_node
    val progress_   : mk_node
    val q_          : mk_node
    val rp_         : mk_node
    val rt_         : mk_node
    val ruby_       : mk_node
    val samp_       : mk_node
    val script_     : mk_node
    val section_    : mk_node
    val select_     : mk_node
    val small_      : mk_node
    val source_     : mk_leaf
    val span_       : mk_node
    val strong_     : mk_node
    val style_      : mk_node    (* element and attribute *)
    val sub_        : mk_node
    val summary_    : mk_node
    val sup_        : mk_node
    val table_      : mk_node
    val tbody_      : mk_node
    val td_         : mk_node
    val textarea_   : mk_node
    val tfoot_      : mk_node
    val th_         : mk_node
    val template_   : mk_node
    val thead_      : mk_node
    val time_       : mk_node
    val title_      : mk_node    (* element and attribute *)
    val tr_         : mk_node
    val track_      : mk_leaf
    val ul_         : mk_node
    val var_        : mk_node
    val video_      : mk_node
    val wbr_        : mk_leaf

  end

  (** The [At] module contains all of the HTML 5 attribute names *)
  module At : sig

    type mk_attr = string -> attrs

    (** Merge attr sets together *)
    val (@) : attrs -> attrs -> attrs

    val accept_             : mk_attr
    val acceptCharset_      : mk_attr
    val accesskey_          : mk_attr
    val action_             : mk_attr
    val alt_                : mk_attr
    val async_              : mk_attr
    val autocomplete_       : mk_attr
    val autofocus_          : mk_attr
    val autoplay_           : mk_attr
    val challenge_          : mk_attr
    val charset_            : mk_attr
    val checked_            : mk_attr
    val cite_               : mk_attr
    val class_              : mk_attr
    val cols_               : mk_attr
    val colspan_            : mk_attr
    val content_            : mk_attr
    val contenteditable_    : mk_attr
    val contextmenu_        : mk_attr
    val controls_           : mk_attr
    val coords_             : mk_attr
    val data_               : mk_attr
    val datetime_           : mk_attr
    val defer_              : mk_attr
    val dir_                : mk_attr
    val disabled_           : mk_attr
    val draggable_          : mk_attr
    val enctype_            : mk_attr
    val for_                : mk_attr
    val form_               : mk_attr
    val formaction_         : mk_attr
    val formenctype_        : mk_attr
    val formmethod_         : mk_attr
    val formnovalidate_     : mk_attr
    val formtarget_         : mk_attr
    val headers_            : mk_attr
    val height_             : mk_attr
    val hidden_             : mk_attr
    val high_               : mk_attr
    val href_               : mk_attr
    val hreflang_           : mk_attr
    val httpEquiv_          : mk_attr
    val icon_               : mk_attr
    val id_                 : mk_attr
    val ismap_              : mk_attr
    val item_               : mk_attr
    val itemprop_           : mk_attr
    val keytype_            : mk_attr
    val label_              : mk_attr
    val lang_               : mk_attr
    val list_               : mk_attr
    val loop_               : mk_attr
    val low_                : mk_attr
    val manifest_           : mk_attr
    val max_                : mk_attr
    val maxlength_          : mk_attr
    val media_              : mk_attr
    val method_             : mk_attr
    val min_                : mk_attr
    val multiple_           : mk_attr
    val name_               : mk_attr
    val novalidate_         : mk_attr
    val onbeforeonload_     : mk_attr
    val onbeforeprint_      : mk_attr
    val onblur_             : mk_attr
    val oncanplay_          : mk_attr
    val oncanplaythrough_   : mk_attr
    val onchange_           : mk_attr
    val onclick_            : mk_attr
    val oncontextmenu_      : mk_attr
    val ondblclick_         : mk_attr
    val ondrag_             : mk_attr
    val ondragend_          : mk_attr
    val ondragenter_        : mk_attr
    val ondragleave_        : mk_attr
    val ondragover_         : mk_attr
    val ondragstart_        : mk_attr
    val ondrop_             : mk_attr
    val ondurationchange_   : mk_attr
    val onemptied_          : mk_attr
    val onended_            : mk_attr
    val onerror_            : mk_attr
    val onfocus_            : mk_attr
    val onformchange_       : mk_attr
    val onforminput_        : mk_attr
    val onhaschange_        : mk_attr
    val oninput_            : mk_attr
    val oninvalid_          : mk_attr
    val onkeydown_          : mk_attr
    val onkeyup_            : mk_attr
    val onload_             : mk_attr
    val onloadeddata_       : mk_attr
    val onloadedmetadata_   : mk_attr
    val onloadstart_        : mk_attr
    val onmessage_          : mk_attr
    val onmousedown_        : mk_attr
    val onmousemove_        : mk_attr
    val onmouseout_         : mk_attr
    val onmouseover_        : mk_attr
    val onmouseup_          : mk_attr
    val onmousewheel_       : mk_attr
    val ononline_           : mk_attr
    val onpagehide_         : mk_attr
    val onpageshow_         : mk_attr
    val onpause_            : mk_attr
    val onplay_             : mk_attr
    val onplaying_          : mk_attr
    val onprogress_         : mk_attr
    val onpropstate_        : mk_attr
    val onratechange_       : mk_attr
    val onreadystatechange_ : mk_attr
    val onredo_             : mk_attr
    val onresize_           : mk_attr
    val onscroll_           : mk_attr
    val onseeked_           : mk_attr
    val onseeking_          : mk_attr
    val onselect_           : mk_attr
    val onstalled_          : mk_attr
    val onstorage_          : mk_attr
    val onsubmit_           : mk_attr
    val onsuspend_          : mk_attr
    val ontimeupdate_       : mk_attr
    val onundo_             : mk_attr
    val onunload_           : mk_attr
    val onvolumechange_     : mk_attr
    val onwaiting_          : mk_attr
    val open_               : mk_attr
    val optimum_            : mk_attr
    val pattern_            : mk_attr
    val ping_               : mk_attr
    val placeholder_        : mk_attr
    val preload_            : mk_attr
    val pubdate_            : mk_attr
    val radiogroup_         : mk_attr
    val readonly_           : mk_attr
    val rel_                : mk_attr
    val required_           : mk_attr
    val reversed_           : mk_attr
    val rows_               : mk_attr
    val rowspan_            : mk_attr
    val sandbox_            : mk_attr
    val scope_              : mk_attr
    val scoped_             : mk_attr
    val seamless_           : mk_attr
    val selected_           : mk_attr
    val shape_              : mk_attr
    val size_               : mk_attr
    val sizes_              : mk_attr
    val span_               : mk_attr
    val spellcheck_         : mk_attr
    val src_                : mk_attr
    val srcdoc_             : mk_attr
    val start_              : mk_attr
    val step_               : mk_attr
    val style_              : mk_attr
    val subject_            : mk_attr
    val summary_            : mk_attr
    val tabindex_           : mk_attr
    val target_             : mk_attr
    val title_              : mk_attr
    val type_               : mk_attr
    val usemap_             : mk_attr
    val value_              : mk_attr
    val width_              : mk_attr
    val wrap_               : mk_attr
    val xmlns_              : mk_attr

  end

end

(** A functor to extend [S] modules to full [DSL]s *)
module DSL_Of (Core : S) = struct
  include Core

  module El = struct
    type mk_node = ?attributes:attrs -> t list -> t
    type mk_leaf = ?attributes:attrs -> unit -> t

    let a_          = Core.mk_node ~name:"a"
    let abbr_       = Core.mk_node ~name:"abbr"
    let address_    = Core.mk_node ~name:"address"
    let area_       = Core.mk_leaf ~name:"area"
    let article_    = Core.mk_node ~name:"article"
    let aside_      = Core.mk_node ~name:"aside"
    let audio_      = Core.mk_node ~name:"audio"
    let b_          = Core.mk_node ~name:"b"
    let base_       = Core.mk_leaf ~name:"base"
    let bdo_        = Core.mk_node ~name:"bdo"
    let blockquote_ = Core.mk_node ~name:"blockquote"
    let body_       = Core.mk_node ~name:"body"
    let br_         = Core.mk_leaf ~name:"br"
    let button_     = Core.mk_node ~name:"button"
    let canvas_     = Core.mk_node ~name:"canvas"
    let caption_    = Core.mk_node ~name:"caption"
    let cite_       = Core.mk_node ~name:"cite"
    let code_       = Core.mk_node ~name:"code"
    let col_        = Core.mk_leaf ~name:"col"
    let colgroup_   = Core.mk_node ~name:"colgroup"
    let command_    = Core.mk_node ~name:"command"
    let datalist_   = Core.mk_node ~name:"datalist"
    let dd_         = Core.mk_node ~name:"dd"
    let del_        = Core.mk_node ~name:"del"
    let details_    = Core.mk_node ~name:"details"
    let dfn_        = Core.mk_node ~name:"dfn"
    let div_        = Core.mk_node ~name:"div"
    let dl_         = Core.mk_node ~name:"dl"
    let dt_         = Core.mk_node ~name: "dt"
    let em_         = Core.mk_node ~name:"em"
    let embed_      = Core.mk_leaf ~name:"embed"
    let fieldset_   = Core.mk_node ~name:"fieldset"
    let figcaption_ = Core.mk_node ~name:"figcaption"
    let figure_     = Core.mk_node ~name:"figure"
    let footer_     = Core.mk_node ~name:"footer"
    let form_       = Core.mk_node ~name:"form"
    let h1_         = Core.mk_node ~name:"h1"
    let h2_         = Core.mk_node ~name:"h2"
    let h3_         = Core.mk_node ~name:"h3"
    let h4_         = Core.mk_node ~name:"h4"
    let h5_         = Core.mk_node ~name:"h5"
    let h6_         = Core.mk_node ~name:"h6"
    let head_       = Core.mk_node ~name:"head"
    let header_     = Core.mk_node ~name:"header"
    let hgroup_     = Core.mk_node ~name:"hgroup"
    let hr_         = Core.mk_leaf ~name:"hr"
    let html_       = Core.mk_node ~name:"html"
    let i_          = Core.mk_node ~name:"i"
    let iframe_     = Core.mk_node ~name:"iframe"
    let img_        = Core.mk_leaf ~name:"img"
    let input_      = Core.mk_leaf ~name:"input"
    let ins_        = Core.mk_node ~name:"ins"
    let kbd_        = Core.mk_node ~name:"kbd"
    let keygen_     = Core.mk_leaf ~name:"keygen"
    let label_      = Core.mk_node ~name:"label"
    let legend_     = Core.mk_node ~name:"legend"
    let li_         = Core.mk_node ~name:"li"
    let link_       = Core.mk_leaf ~name: "link"
    let map_        = Core.mk_node ~name: "map"
    let main_       = Core.mk_node ~name: "main"
    let mark_       = Core.mk_node ~name: "mark"
    let menu_       = Core.mk_node ~name: "menu"
    let menuitem_   = Core.mk_leaf ~name: "menuitem"
    let meta_       = Core.mk_leaf ~name:"meta"
    let meter_      = Core.mk_node ~name:"meter"
    let nav_        = Core.mk_node ~name:"nav"
    let noscript_   = Core.mk_node ~name:"noscript"
    let object_     = Core.mk_node ~name:"object"
    let ol_         = Core.mk_node ~name:"ol"
    let optgroup_   = Core.mk_node ~name:"optgroup"
    let option_     = Core.mk_node ~name:"option"
    let output_     = Core.mk_node ~name:"output"
    let p_          = Core.mk_node ~name:"p"
    let param_      = Core.mk_leaf ~name:"param"
    let svg_        = Core.mk_node ~name:"svg"
    let pre_        = Core.mk_node ~name:"pre"
    let progress_   = Core.mk_node ~name:"progress"
    let q_          = Core.mk_node ~name:"q"
    let rp_         = Core.mk_node ~name:"rp"
    let rt_         = Core.mk_node ~name:"rt"
    let ruby_       = Core.mk_node ~name:"ruby"
    let samp_       = Core.mk_node ~name:"samp"
    let script_     = Core.mk_node ~name:"script"
    let section_    = Core.mk_node ~name:"section"
    let select_     = Core.mk_node ~name:"select"
    let small_      = Core.mk_node ~name:"small"
    let source_     = Core.mk_leaf ~name:"source"
    let span_       = Core.mk_node ~name:"span"
    let strong_     = Core.mk_node ~name:"strong"
    let style_      = Core.mk_node ~name:"style"
    let sub_        = Core.mk_node ~name:"sub"
    let summary_    = Core.mk_node ~name:"summary"
    let sup_        = Core.mk_node ~name:"sup"
    let table_      = Core.mk_node ~name:"table"
    let tbody_      = Core.mk_node ~name:"tbody"
    let td_         = Core.mk_node ~name:"td"
    let textarea_   = Core.mk_node ~name:"textarea"
    let tfoot_      = Core.mk_node ~name:"tfoot"
    let th_         = Core.mk_node ~name:"th"
    let template_   = Core.mk_node ~name:"template"
    let thead_      = Core.mk_node ~name:"thead"
    let time_       = Core.mk_node ~name:"time"
    let title_      = Core.mk_node ~name:"title"
    let tr_         = Core.mk_node ~name:"tr"
    let track_      = Core.mk_leaf ~name:"track"
    let ul_         = Core.mk_node ~name:"ul"
    let var_        = Core.mk_node ~name:"var"
    let video_      = Core.mk_node ~name:"video"
    let wbr_        = Core.mk_leaf ~name:"wbr"
  end

  module At = struct
    type mk_attr = string -> attrs

    let accept_             = Core.mk_attr ~name:"accept"
    let acceptCharset_      = Core.mk_attr ~name:"acceptCharset"
    let accesskey_          = Core.mk_attr ~name:"accesskey"
    let action_             = Core.mk_attr ~name:"action"
    let alt_                = Core.mk_attr ~name:"alt"
    let async_              = Core.mk_attr ~name:"async"
    let autocomplete_       = Core.mk_attr ~name:"autocomplete"
    let autofocus_          = Core.mk_attr ~name:"autofocus"
    let autoplay_           = Core.mk_attr ~name:"autoplay"
    let challenge_          = Core.mk_attr ~name:"challenge"
    let charset_            = Core.mk_attr ~name:"charset"
    let checked_            = Core.mk_attr ~name:"checked"
    let cite_               = Core.mk_attr ~name:"cite"
    let class_              = Core.mk_attr ~name:"class"
    let cols_               = Core.mk_attr ~name:"cols"
    let colspan_            = Core.mk_attr ~name:"colspan"
    let content_            = Core.mk_attr ~name:"content"
    let contenteditable_    = Core.mk_attr ~name:"contenteditable"
    let contextmenu_        = Core.mk_attr ~name:"contextmenu"
    let controls_           = Core.mk_attr ~name:"controls"
    let coords_             = Core.mk_attr ~name:"coords"
    let data_               = Core.mk_attr ~name:"data"
    let datetime_           = Core.mk_attr ~name:"datetime"
    let defer_              = Core.mk_attr ~name:"defer"
    let dir_                = Core.mk_attr ~name:"dir"
    let disabled_           = Core.mk_attr ~name:"disabled"
    let draggable_          = Core.mk_attr ~name:"draggable"
    let enctype_            = Core.mk_attr ~name:"enctype"
    let for_                = Core.mk_attr ~name:"for"
    let form_               = Core.mk_attr ~name:"form"
    let formaction_         = Core.mk_attr ~name:"formaction"
    let formenctype_        = Core.mk_attr ~name:"formenctype"
    let formmethod_         = Core.mk_attr ~name:"formmethod"
    let formnovalidate_     = Core.mk_attr ~name:"formnovalidate"
    let formtarget_         = Core.mk_attr ~name:"formtarget"
    let headers_            = Core.mk_attr ~name:"headers"
    let height_             = Core.mk_attr ~name:"height"
    let hidden_             = Core.mk_attr ~name:"hidden"
    let high_               = Core.mk_attr ~name:"high"
    let href_               = Core.mk_attr ~name:"href"
    let hreflang_           = Core.mk_attr ~name:"hreflang"
    let httpEquiv_          = Core.mk_attr ~name:"httpEquiv"
    let icon_               = Core.mk_attr ~name:"icon"
    let id_                 = Core.mk_attr ~name:"id"
    let ismap_              = Core.mk_attr ~name:"ismap"
    let item_               = Core.mk_attr ~name:"item"
    let itemprop_           = Core.mk_attr ~name:"itemprop"
    let keytype_            = Core.mk_attr ~name:"keytype"
    let label_              = Core.mk_attr ~name:"label"
    let lang_               = Core.mk_attr ~name:"lang"
    let list_               = Core.mk_attr ~name:"list"
    let loop_               = Core.mk_attr ~name:"loop"
    let low_                = Core.mk_attr ~name:"low"
    let manifest_           = Core.mk_attr ~name:"manifest"
    let max_                = Core.mk_attr ~name:"max"
    let maxlength_          = Core.mk_attr ~name:"maxlength"
    let media_              = Core.mk_attr ~name:"media"
    let method_             = Core.mk_attr ~name:"method"
    let min_                = Core.mk_attr ~name:"min"
    let multiple_           = Core.mk_attr ~name:"multiple"
    let name_               = Core.mk_attr ~name:"name"
    let novalidate_         = Core.mk_attr ~name:"novalidate"
    let onbeforeonload_     = Core.mk_attr ~name:"onbeforeonload"
    let onbeforeprint_      = Core.mk_attr ~name:"onbeforeprint"
    let onblur_             = Core.mk_attr ~name:"onblur"
    let oncanplay_          = Core.mk_attr ~name:"oncanplay"
    let oncanplaythrough_   = Core.mk_attr ~name:"oncanplaythrough"
    let onchange_           = Core.mk_attr ~name:"onchange"
    let onclick_            = Core.mk_attr ~name:"onclick"
    let oncontextmenu_      = Core.mk_attr ~name:"oncontextmenu"
    let ondblclick_         = Core.mk_attr ~name:"ondblclick"
    let ondrag_             = Core.mk_attr ~name:"ondrag"
    let ondragend_          = Core.mk_attr ~name:"ondragend"
    let ondragenter_        = Core.mk_attr ~name:"ondragenter"
    let ondragleave_        = Core.mk_attr ~name:"ondragleave"
    let ondragover_         = Core.mk_attr ~name:"ondragover"
    let ondragstart_        = Core.mk_attr ~name:"ondragstart"
    let ondrop_             = Core.mk_attr ~name:"ondrop"
    let ondurationchange_   = Core.mk_attr ~name:"ondurationchange"
    let onemptied_          = Core.mk_attr ~name:"onemptied"
    let onended_            = Core.mk_attr ~name:"onended"
    let onerror_            = Core.mk_attr ~name:"onerror"
    let onfocus_            = Core.mk_attr ~name:"onfocus"
    let onformchange_       = Core.mk_attr ~name:"onformchange"
    let onforminput_        = Core.mk_attr ~name:"onforminput"
    let onhaschange_        = Core.mk_attr ~name:"onhaschange"
    let oninput_            = Core.mk_attr ~name:"oninput"
    let oninvalid_          = Core.mk_attr ~name:"oninvalid"
    let onkeydown_          = Core.mk_attr ~name:"onkeydown"
    let onkeyup_            = Core.mk_attr ~name:"onkeyup"
    let onload_             = Core.mk_attr ~name:"onload"
    let onloadeddata_       = Core.mk_attr ~name:"onloadeddata"
    let onloadedmetadata_   = Core.mk_attr ~name:"onloadedmetadata"
    let onloadstart_        = Core.mk_attr ~name:"onloadstart"
    let onmessage_          = Core.mk_attr ~name:"onmessage"
    let onmousedown_        = Core.mk_attr ~name:"onmousedown"
    let onmousemove_        = Core.mk_attr ~name:"onmousemove"
    let onmouseout_         = Core.mk_attr ~name:"onmouseout"
    let onmouseover_        = Core.mk_attr ~name:"onmouseover"
    let onmouseup_          = Core.mk_attr ~name:"onmouseup"
    let onmousewheel_       = Core.mk_attr ~name:"onmousewheel"
    let ononline_           = Core.mk_attr ~name:"ononline"
    let onpagehide_         = Core.mk_attr ~name:"onpagehide"
    let onpageshow_         = Core.mk_attr ~name:"onpageshow"
    let onpause_            = Core.mk_attr ~name:"onpause"
    let onplay_             = Core.mk_attr ~name:"onplay"
    let onplaying_          = Core.mk_attr ~name:"onplaying"
    let onprogress_         = Core.mk_attr ~name:"onprogress"
    let onpropstate_        = Core.mk_attr ~name:"onpropstate"
    let onratechange_       = Core.mk_attr ~name:"onratechange"
    let onreadystatechange_ = Core.mk_attr ~name:"onreadystatechange"
    let onredo_             = Core.mk_attr ~name:"onredo"
    let onresize_           = Core.mk_attr ~name:"onresize"
    let onscroll_           = Core.mk_attr ~name:"onscroll"
    let onseeked_           = Core.mk_attr ~name:"onseeked"
    let onseeking_          = Core.mk_attr ~name:"onseeking"
    let onselect_           = Core.mk_attr ~name:"onselect"
    let onstalled_          = Core.mk_attr ~name:"onstalled"
    let onstorage_          = Core.mk_attr ~name:"onstorage"
    let onsubmit_           = Core.mk_attr ~name:"onsubmit"
    let onsuspend_          = Core.mk_attr ~name:"onsuspend"
    let ontimeupdate_       = Core.mk_attr ~name:"ontimeupdate"
    let onundo_             = Core.mk_attr ~name:"onundo"
    let onunload_           = Core.mk_attr ~name:"onunload"
    let onvolumechange_     = Core.mk_attr ~name:"onvolumechange"
    let onwaiting_          = Core.mk_attr ~name:"onwaiting"
    let open_               = Core.mk_attr ~name:"open"
    let optimum_            = Core.mk_attr ~name:"optimum"
    let pattern_            = Core.mk_attr ~name:"pattern"
    let ping_               = Core.mk_attr ~name:"ping"
    let placeholder_        = Core.mk_attr ~name:"placeholder"
    let preload_            = Core.mk_attr ~name:"preload"
    let pubdate_            = Core.mk_attr ~name:"pubdate"
    let radiogroup_         = Core.mk_attr ~name:"radiogroup"
    let readonly_           = Core.mk_attr ~name:"readonly"
    let rel_                = Core.mk_attr ~name:"rel"
    let required_           = Core.mk_attr ~name:"required"
    let reversed_           = Core.mk_attr ~name:"reversed"
    let rows_               = Core.mk_attr ~name:"rows"
    let rowspan_            = Core.mk_attr ~name:"rowspan"
    let sandbox_            = Core.mk_attr ~name:"sandbox"
    let scope_              = Core.mk_attr ~name:"scope"
    let scoped_             = Core.mk_attr ~name:"scoped"
    let seamless_           = Core.mk_attr ~name:"seamless"
    let selected_           = Core.mk_attr ~name:"selected"
    let shape_              = Core.mk_attr ~name:"shape"
    let size_               = Core.mk_attr ~name:"size"
    let sizes_              = Core.mk_attr ~name:"sizes"
    let span_               = Core.mk_attr ~name:"span"
    let spellcheck_         = Core.mk_attr ~name:"spellcheck"
    let src_                = Core.mk_attr ~name:"src"
    let srcdoc_             = Core.mk_attr ~name:"srcdoc"
    let start_              = Core.mk_attr ~name:"start"
    let step_               = Core.mk_attr ~name:"step"
    let style_              = Core.mk_attr ~name:"style"
    let subject_            = Core.mk_attr ~name:"subject"
    let summary_            = Core.mk_attr ~name:"summary"
    let tabindex_           = Core.mk_attr ~name:"tabindex"
    let target_             = Core.mk_attr ~name:"target"
    let title_              = Core.mk_attr ~name:"title"
    let type_               = Core.mk_attr ~name:"type"
    let usemap_             = Core.mk_attr ~name:"usemap"
    let value_              = Core.mk_attr ~name:"value"
    let width_              = Core.mk_attr ~name:"width"
    let wrap_               = Core.mk_attr ~name:"wrap"
    let xmlns_              = Core.mk_attr ~name:"xmlns"
  end
end
