import os
import sys

file_path = '../Yelp-JSON/yelp_academic_dataset_review.json'
os.chdir('./chunck_files')
chunck_file_number = 40
line_cnt = 0
output_prefix = 'split_file'
with open(file_path, 'r', encoding='utf8') as f:
    line_cnt = sum([1 for _ in f])

lines_per_file = line_cnt // chunck_file_number
print(f'there will be {chunck_file_number} chunck files and each file will consist of {lines_per_file} number of lines')


# we split review file into chunck files to upload those to s3 parallel


with open(file_path, 'r', encoding='utf8') as f:
    for file_name in range(1, chunck_file_number+1):
        output_name = f'{output_prefix}{file_name}.json '
        print(output_name)
        with open(output_name, 'w', encoding='utf8') as out_file:
            for _ in range(lines_per_file):
                line = f.readline()
                if not line:
                    print('error in the file')
                    break
                out_file.write(line)
print(f'{chunck_file_number} chunck files created successfully')