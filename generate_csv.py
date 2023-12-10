import xml.dom.minidom
import csv

def generate_csv(xml_file):
    # Otevření XML souboru
    dom = xml.dom.minidom.parse(xml_file)

    # Příprava CSV souboru pro zápis
    csv_file = "output.csv"  # Název výstupního CSV souboru
    csv_writer = csv.writer(open(csv_file, 'w', newline=''))

    # Zápis hlavičky CSV souboru
    csv_writer.writerow(["Jméno", "Rok narození", "Tituly", "Týdenní hodinový rozsah"])

    # Nalezení všech vyučujících
    teachers_elements = dom.getElementsByTagName("vyučující")

    for teacher_element in teachers_elements:
        name = teacher_element.getElementsByTagName("jméno_příjmení")[0].firstChild.nodeValue
        age_birth = teacher_element.getElementsByTagName("rok_narození")[0].firstChild.nodeValue
        degrees_before = teacher_element.getElementsByTagName("tituly_před")[
            0].firstChild.nodeValue if teacher_element.getElementsByTagName("tituly_před") else ""
        degrees_after = teacher_element.getElementsByTagName("tituly_za")[
            0].firstChild.nodeValue if teacher_element.getElementsByTagName("tituly_za") else ""
        hours_week = teacher_element.getElementsByTagName("rozsah")[0].firstChild.nodeValue

        # Sloučení "Tituly před" a "Tituly za" do jednoho řetězce
        degrees = f"{degrees_before} {degrees_after}"

        # Zápis dat do CSV souboru
        csv_writer.writerow([name, age_birth, degrees, hours_week])

generate_csv('zadost2.xml')
