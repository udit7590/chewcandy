module AnnotationsHelper
  ANNOTATIONS = {
    '**' => 'Prices are inclusive of taxes',
    '*'  => 'For products whose prices are not inclusive of taxes'
  }.freeze

  ANNOTATION_HUMAN = {
    prices_inclusive_taxes: '**'
  }.freeze

  def taxes_inclusive_annotation(product)
    if product.tax_inclusive?
      '**'
    end
  end

  def taxes_note_annotation
    '*'
  end  

  def annotation_message(annotation)
    "#{ annotation } #{ ANNOTATIONS[annotation.to_s] }"
  end

  def annotation_messages
    ANNOTATIONS.map do |annotation, message|
      annotation + ' ' + annotation_message(annotation)
    end.join('<br />').html_safe
  end
end
