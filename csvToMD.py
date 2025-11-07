import argparse
import csv
import re

# Define input CSV file and output Markdown file
output_file = "output.md"
encoding = "utf-8"



def process_value(value,remove_newlines=True):
    """Process the CSV value, replacing empty values with !!MISSING!! and cleaning up text."""
    if not value:
        return "!!MISSING!!"
    
    # Strip unwanted characters including U+000B and other control characters
    value = value.strip()
    print(value)
    value = re.sub(r"[^\t\n\r -~À-ÿ]", "", value)  # Keep printable ASCII + extended Latin (French accents)
    # Remove control characters
    if remove_newlines:
        value=value.replace(u"\n",u"\n\n")
        value = re.sub(r"^[ \t]+", "", value, flags=re.MULTILINE)

    print("###"*10)
    print(value)
    print("--------------------------------------------------------------------------")
    return value

    



# Define the Markdown preamble
preamble = """---
title: {}
date: 2025-2026
author: MIAGE Sorbonne
titlepage: true
titlepage-color: "267b88"
toc-own-page: true
book: true
logo-width: 25 em
titlepage-logo: MIAGE_LOGO_CMJN_SORBONNE-scaled.jpg
number-sections: true
titlepage-background: background10.pdf
titlepage-rule-color: "360049"
---
"""

def get_md(input,the_promo):
    # Read CSV and generate Markdown content
    with open(input, mode='r', encoding=encoding) as csv_file:
        reader = csv.DictReader(csv_file, delimiter=';', quotechar='"')
        
        # Start writing the Markdown content
        markdown_content = []
        
        for row in reader:
            # Skip empty lines
            if not any(row.values()):
                continue
            
            # Extract and process values
            promo = process_value(row.get("promo", ""))
            libele = process_value(row.get("Libellé", ""))
            code = process_value(row.get("Code", ""))
            mots_cles = process_value(row.get("mots clés", ""),remove_newlines=False)
            langues = process_value(row.get("Langues d'enseignement", ""))
            description = process_value(row.get("Description", ""))
            objectifs = process_value(row.get("Objectifs", ""))
            prerequis = process_value(row.get("Pré-requis obligatoires", ""))
            competences_visees = process_value(row.get("Compétences Visées", ""))
            controle = process_value(row.get("Contrôle des connaissances", ""))
            syllabus = process_value(row.get("Syllabus / Méthodes Pédagogiques", ""))
            bibliographie = process_value(row.get("Bibliographie", ""))
            
            # Create Markdown section
            section = f"""
# {libele} ({code})

{description}

* mots clés: **{mots_cles}**
* le cours est assuré en **{langues}**



## Objectifs

{objectifs}

## Pré-requis et compétences

### Prérequis 

{prerequis}

### Compétences Visées

{competences_visees}

## Contrôle des connaissances

{controle}

## Syllabus / Méthodes Pédagogiques

{syllabus}

## Bibliographie

{bibliographie}
\\newpage
    """
            if promo==the_promo or promo=="IBI/SBI":
                markdown_content.append(section)
    return markdown_content
        

preamble

md_ibi_s1=get_md("M1S1-UTF8.csv","IBI")
md_ibi_s2=get_md("M1S2-UTF8.csv","IBI")

md_sbi_s1=get_md("M1S1-UTF8.csv","SBI")
md_sbi_s2=get_md("M1S2-UTF8.csv","SBI")

md_m2ibi_s1=get_md("M2S1-UTF8.csv","IBI")
md_m2ibi_s2=get_md("M2S2-UTF8.csv","IBI")

md_m2sbi_s1=get_md("M2S1-UTF8.csv","SBI")
md_m2sbi_s2=get_md("M2S2-UTF8.csv","SBI")

    
# Write the Markdown output
with open("M1IBI.md", mode='w', encoding="utf-8") as md_file:
    md_file.write(preamble.format("M1 Intelligent Business Informatics"))
    md_file.write("\\chapter{Premier semestre}\n")
    md_file.write("\n".join(md_ibi_s1))
    md_file.write("\\chapter{Deuxième semestre}\n")
    md_file.write("\n".join(md_ibi_s2))

# Write the Markdown output
with open("M1SBI.md", mode='w', encoding="utf-8") as md_file:
    md_file.write(preamble.format("M1 Sustainable Business Informatics"))
    md_file.write("\\chapter{Premier semestre}\n")
    md_file.write("\n".join(md_sbi_s1))
    md_file.write("\\chapter{Deuxième semestre}\n")
    md_file.write("\n".join(md_sbi_s2))

    
# Write the Markdown output
with open("M2IBI.md", mode='w', encoding="utf-8") as md_file:
    md_file.write(preamble.format("M2 Intelligent Business Informatics"))
    md_file.write("\\chapter{Premier semestre}\n")
    md_file.write("\n".join(md_m2sbi_s1))
    md_file.write("\\chapter{Deuxième semestre}\n")
    md_file.write("\n".join(md_m2sbi_s2))

# Write the Markdown output
with open("M2SBI.md", mode='w', encoding="utf-8") as md_file:
    md_file.write(preamble.format("M2 Sustainable Business Informatics"))
    md_file.write("\\chapter{Premier semestre}\n")
    md_file.write("\n".join(md_m2sbi_s2))
    md_file.write("\\chapter{Deuxième semestre}\n")
    md_file.write("\n".join(md_m2sbi_s2))
    
print(f"Markdown file '{output_file}' generated successfully.")
