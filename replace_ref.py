from lxml import etree

def replace_ref(input_file):
    tree = etree.parse(input_file)

    # Získáme elementy s atributem idref
    elements_to_replace = tree.xpath('//ref[@idref]')
    # Pro každý takový element provedete nahrazení
    for element in elements_to_replace:
        idref_value = element.get("idref")  # Získáme hodnotu atributu idref

        # Získáme identifikátor a parametr z hodnoty idref
        id_value = idref_value.split("/")[0]
        parameter_value = "/".join(idref_value.split("/")[1:])

        # Hledáme element s odpovídajícím id
        matching_element = tree.xpath(f'//*[@id="{id_value}"]/{parameter_value}')[0]

        span_element = etree.Element("span")
        span_element.text = matching_element.text  # Nahrazení textu

        parent = element.getparent()
        parent.replace(element, span_element)

        # Přidáme 'tail' text tohoto elementu do 'tail' textu rodiče pokud existuje

        if element.tail:
            if span_element.tail:
                span_element.tail += element.tail
            else:
                span_element.tail = element.tail

        # Uložíme změny do nového souboru
    output_file = "replaced.xml"
    tree.write(output_file, encoding="utf-8", pretty_print=True)

replace_ref('zadost2.xml')
