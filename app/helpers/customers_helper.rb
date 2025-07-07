module CustomersHelper
  def document_type_label(customer)
    {
      "C" => "Cédula de ciudadanía",
      "E" => "Cédula de extranjería",
      "N" => "NIT",
      "T" => "Tarjeta de identidad"
    }[customer.document_type] || "Desconocido"
  end
end