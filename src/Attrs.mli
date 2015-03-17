
type t

module Value = Value

val to_buf : t -> Buf.t
val to_string : t -> string

module Prop : sig
  type t

  val equal   : t -> t -> bool
  val compare : t -> t -> int

  val to_string : t -> string
  val of_string : string -> t

  val accept_             : t
  val accept_charset_     : t
  val accesskey_          : t
  val action_             : t
  val alt_                : t
  val async_              : t
  val autocomplete_       : t
  val autofocus_          : t
  val autoplay_           : t
  val challenge_          : t
  val charset_            : t
  val checked_            : t
  val cite_               : t
  val class_              : t
  val cols_               : t
  val colspan_            : t
  val content_            : t
  val contenteditable_    : t
  val contextmenu_        : t
  val controls_           : t
  val coords_             : t
  val data_               : t
  val datetime_           : t
  val defer_              : t
  val dir_                : t
  val disabled_           : t
  val draggable_          : t
  val enctype_            : t
  val for_                : t
  val form_               : t
  val formaction_         : t
  val formenctype_        : t
  val formmethod_         : t
  val formnovalidate_     : t
  val formtarget_         : t
  val headers_            : t
  val height_             : t
  val hidden_             : t
  val high_               : t
  val href_               : t
  val hreflang_           : t
  val httpEquiv_          : t
  val icon_               : t
  val id_                 : t
  val ismap_              : t
  val item_               : t
  val itemprop_           : t
  val keytype_            : t
  val label_              : t
  val lang_               : t
  val list_               : t
  val loop_               : t
  val low_                : t
  val manifest_           : t
  val max_                : t
  val maxlength_          : t
  val media_              : t
  val method_             : t
  val min_                : t
  val multiple_           : t
  val name_               : t
  val novalidate_         : t
  val onbeforeonload_     : t
  val onbeforeprint_      : t
  val onblur_             : t
  val oncanplay_          : t
  val oncanplaythrough_   : t
  val onchange_           : t
  val onclick_            : t
  val oncontextmenu_      : t
  val ondblclick_         : t
  val ondrag_             : t
  val ondragend_          : t
  val ondragenter_        : t
  val ondragleave_        : t
  val ondragover_         : t
  val ondragstart_        : t
  val ondrop_             : t
  val ondurationchange_   : t
  val onemptied_          : t
  val onended_            : t
  val onerror_            : t
  val onfocus_            : t
  val onformchange_       : t
  val onforminput_        : t
  val onhaschange_        : t
  val oninput_            : t
  val oninvalid_          : t
  val onkeydown_          : t
  val onkeyup_            : t
  val onload_             : t
  val onloadeddata_       : t
  val onloadedmetadata_   : t
  val onloadstart_        : t
  val onmessage_          : t
  val onmousedown_        : t
  val onmousemove_        : t
  val onmouseout_         : t
  val onmouseover_        : t
  val onmouseup_          : t
  val onmousewheel_       : t
  val ononline_           : t
  val onpagehide_         : t
  val onpageshow_         : t
  val onpause_            : t
  val onplay_             : t
  val onplaying_          : t
  val onprogress_         : t
  val onpropstate_        : t
  val onratechange_       : t
  val onreadystatechange_ : t
  val onredo_             : t
  val onresize_           : t
  val onscroll_           : t
  val onseeked_           : t
  val onseeking_          : t
  val onselect_           : t
  val onstalled_          : t
  val onstorage_          : t
  val onsubmit_           : t
  val onsuspend_          : t
  val ontimeupdate_       : t
  val onundo_             : t
  val onunload_           : t
  val onvolumechange_     : t
  val onwaiting_          : t
  val open_               : t
  val optimum_            : t
  val pattern_            : t
  val ping_               : t
  val placeholder_        : t
  val preload_            : t
  val pubdate_            : t
  val radiogroup_         : t
  val readonly_           : t
  val rel_                : t
  val required_           : t
  val reversed_           : t
  val rows_               : t
  val rowspan_            : t
  val sandbox_            : t
  val scope_              : t
  val scoped_             : t
  val seamless_           : t
  val selected_           : t
  val shape_              : t
  val size_               : t
  val sizes_              : t
  val span_               : t
  val spellcheck_         : t
  val src_                : t
  val srcdoc_             : t
  val start_              : t
  val step_               : t
  val style_              : t
  val subject_            : t
  val summary_            : t
  val tabindex_           : t
  val target_             : t
  val title_              : t
  val type_               : t
  val usemap_             : t
  val value_              : t
  val width_              : t
  val wrap_               : t
  val xmlns_              : t
end

include Types.CapSet.S
  with type prop := Prop.t
   and type value := Value.t
   and type t := t
