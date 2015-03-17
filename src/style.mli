
type t

module Value : Stringlike.S

val to_buf : t -> Buf.t
val to_string : t -> string

module Prop : sig
  type t

  val equal   : t -> t -> bool
  val compare : t -> t -> int

  val to_string : t -> string
  val of_string : string -> t

  val font_                  : t
  val font_family_           : t
  val font_size_             : t
  val font_weight_           : t
  val font_style_            : t
  val font_variant_          : t
  val line_height_           : t
  val letter_spacing_        : t
  val word_spacing_          : t
  val text_align_            : t
  val text_decoration_       : t
  val text_indent_           : t
  val text_transform_        : t
  val vertical_align_        : t
  val white_space_           : t

  val color_                 : t
  val background_color_      : t
  val background_            : t
  val background_image_      : t
  val background_repeat_     : t
  val background_position_   : t
  val background_attachment_ : t

  val padding_               : t
  val padding_top_           : t
  val padding_right_         : t
  val padding_bottom_        : t
  val padding_left_          : t
  val border_                : t
  val border_top_            : t
  val border_right_          : t
  val border_bottom_         : t
  val border_left_           : t
  val border_style_          : t
  val border_top_style_      : t
  val border_right_style_    : t
  val border_bottom_style_   : t
  val border_left_style_     : t
  val border_color_          : t
  val border_top_color_      : t
  val border_right_color_    : t
  val border_bottom_color_   : t
  val border_left_color_     : t
  val border_width_          : t
  val border_top_width_      : t
  val border_right_width_    : t
  val border_bottom_width_   : t
  val border_left_width_     : t
  val outline_               : t
  val outline_style_         : t
  val outline_color_         : t
  val outline_width_         : t
  val margin_                : t
  val margin_top_            : t
  val margin_right_          : t
  val margin_bottom_         : t
  val margin_left_           : t
  val width_                 : t
  val height_                : t
  val min_width_             : t
  val max_width_             : t
  val min_height_            : t
  val max_height_            : t

  val position_              : t
  val top_                   : t
  val right_                 : t
  val bottom_                : t
  val left_                  : t
  val clip_                  : t
  val overflow_              : t
  val z_index_               : t
  val float_                 : t
  val clear_                 : t
  val display_               : t
  val visibility_            : t

  val list_style_            : t
  val list_style_type_       : t
  val list_style_image_      : t
  val list_style_position_   : t

  val table_layout_          : t
  val border_collapse_       : t
  val border_spacing_        : t
  val empty_cells_           : t
  val caption_side_          : t

  val content_               : t
  val counter_increment      : t
  val counter_reset_         : t
  val quotes_                : t

  val page_break_before_     : t
  val page_break_after_      : t
  val page_break_inside_     : t
  val orphans_               : t
  val widows_                : t

  val cursor_                : t
  val direction_             : t
  val unicode_bidi_          : t
end

include Types.CapSet.S
  with type prop := Prop.t
   and type value := Value.t
   and type t := t
