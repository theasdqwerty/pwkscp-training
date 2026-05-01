import re
import sys

def extract_ips(filename):
    with open(filename) as f:
        data = f.read()
    # Ищем все IPv4-адреса
    ips = set(re.findall(r'\b(?:\d{1,3}\.){3}\d{1,3}\b', data))
    return sorted(ips)

if __name__ == '__main__':
    input_file = 'dnsrecon_subnet.txt'
    output_file = 'ips_only.txt'

    if len(sys.argv) > 1:
        input_file = sys.argv[1]
    if len(sys.argv) > 2:
        output_file = sys.argv[2]

    ips = extract_ips(input_file)
    with open(output_file, 'w') as out:
        out.write('\n'.join(ips))

    print(f"Найдено уникальных IP: {len(ips)}")
