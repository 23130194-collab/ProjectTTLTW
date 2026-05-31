import os
import re

def convert_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # We want to find ${...} that are NOT inside <...>.
    # A simple parser: keep track of whether we are inside a tag.
    # Note: This is a basic parser. It assumes < and > are balanced for HTML/JSP tags.
    result = []
    i = 0
    in_tag = False
    in_el = False
    
    while i < len(content):
        if content[i:i+4] == '<%--': # Skip JSP comments
            end_idx = content.find('--%>', i)
            if end_idx == -1: end_idx = len(content)
            else: end_idx += 4
            result.append(content[i:end_idx])
            i = end_idx
            continue

        if content[i:i+2] == '<%': # Skip scriptlets
            end_idx = content.find('%>', i)
            if end_idx == -1: end_idx = len(content)
            else: end_idx += 2
            result.append(content[i:end_idx])
            i = end_idx
            continue

        if content[i] == '<':
            in_tag = True
            result.append('<')
            i += 1
            continue
            
        if content[i] == '>':
            in_tag = False
            result.append('>')
            i += 1
            continue

        if content[i:i+2] == '${' and not in_tag:
            # We are entering an EL expression outside of a tag
            end_idx = content.find('}', i)
            if end_idx != -1:
                el_expr = content[i:end_idx+1]
                # Replace inner double quotes with single quotes to avoid breaking value="..."
                el_expr = el_expr.replace('"', "'")
                # Replace with <c:out>
                result.append(f'<c:out value="{el_expr}" />')
                i = end_idx + 1
                continue

        result.append(content[i])
        i += 1

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(''.join(result))

if __name__ == "__main__":
    base_dir = r"e:\ProjectTTLTW\demo1\src\main\webapp"
    count = 0
    for file in os.listdir(base_dir):
        if file.endswith('.jsp'):
            filepath = os.path.join(base_dir, file)
            convert_file(filepath)
            count += 1
    print(f"Converted {count} files.")
