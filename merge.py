from lxml import etree

def merge_elements(target_element, source_element):
    # Projdeme všechny děti zdrojového elementu
    for source_child in source_element:
        # Zkontrolujeme, zda jméno zdrojového dítěte není obsaženo v dětech cílového elementu
        exists_in_target = any(target_child.tag == source_child.tag for target_child in target_element)
        if not exists_in_target:
            # Klonujeme zdrojové dítě a přidáme ho do cílového elementu
            target_child = etree.Element(source_child.tag)
            if source_child.text is not None:  # Kontrola, zda atribut má platnou hodnotu
                target_child.text = source_child.text  # Přeneseme atributy s kontrolou hodnoty
            target_element.append(target_child)

            for attr, value in source_child.items():
                target_child.set(attr, value)

def recursive_merge(target_element, source_element, source_elements):
    if source_element is not None:
        # Provedeme merge mezi cílovým a zdrojovým elementem
        merge_elements(target_element, source_element)

        source_merge = source_element.get('{https://ki.ujep.cz/template}merge')
        if source_merge is not None:
            # Rozdělíme více hodnot v atributu tmpl:merge pomocí mezer jako oddělovače
            source_merge_list = source_merge.split()
            for source_merge_item in source_merge_list:
                if source_merge_item in source_elements:
                    recursive_merge(target_element, source_elements[source_merge_item], source_elements)

def perform_merge(xml_file):
    # Načteme XML dokument
    parser = etree.XMLParser(resolve_entities=False)
    tree = etree.parse(xml_file, parser=parser)
    root = tree.getroot()

    # Vytvoříme slovník, kde klíče budou hodnoty atributu xml:id a hodnoty budou samotné elementy
    source_elements = {}

    # Projdeme všechny elementy v dokumentu
    for element in root.iter():
        # Získáme hodnotu atributu xml:id
        xml_id = element.get('{http://www.w3.org/XML/1998/namespace}id')
        if xml_id is not None:
            # Přidáme element do slovníku source_elements
            source_elements[xml_id] = element

    # Hledáme všechny cílové elementy s atributem tmpl:merge
    for target_element in root.iter():
        tmpl_merge = target_element.get('{https://ki.ujep.cz/template}merge')
        if tmpl_merge is not None:
            # Najdeme zdrojový element s odpovídajícím xml:id
            source_element = source_elements.get(tmpl_merge)
            if source_element is not None:
                # Provedeme rekurzivní merge
                recursive_merge(target_element, source_element, source_elements)

    # Uložíme upravený XML dokument
    xml_string = etree.tostring(root, encoding='utf-8', xml_declaration=True, pretty_print=True)

    with open('merged_program.xml', 'wb') as output_file:
        output_file.write(xml_string)
