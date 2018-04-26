% TO RUN TEST
% results = runtests('generate_mirror_csv_test.m')
function  tests = generate_mirror_csv_test
tests = functiontests(localfunctions);
end

function mirror_coordinates_test(testCase)
generate_mirror_csv('mirror_test_id_14g3rb3rb7hffh8.csv','generated_id_pboini083hf02.csv') 
% open csv file to read annotation 
File = fopen('generated_id_pboini083hf02.csv', 'r');
lines = textscan(File, '%s');
fclose('all');

lines = lines{1};

expected_lines = ["Acrorad_0712-1001-1-07-02201.jpg,749,314,774,343,round_single"
                  "Acrorad_0712-1001-1-07-02201x.jpg,506,314,531,343,round_single"
                  "Acrorad_0712-1001-1-07-02201y.jpg,749,681,774,710,round_single"
                  "Acrorad_0712-1001-1-07-02201xy.jpg,506,681,531,710,round_single"];
for ind=1:length(lines)
    line = lines(ind);
    actual_solution = line{1};
    expected_solution = char(expected_lines(ind));
    verifyEqual(testCase,actual_solution,expected_solution)
end
delete mirror_test_id_14g3rb3rb7hffh8.csv
delete generated_id_pboini083hf02.csv
end

function mirror_no_defect_annotation_test(testCase)
generate_mirror_csv('mirror_test_id_1hraeuru5eugete.csv','generated_id_adgaegeab.csv') 
% open csv file to read annotation 
File = fopen('generated_id_adgaegeab.csv', 'r');
lines = textscan(File, '%s');
fclose('all');

lines = lines{1};

expected_lines = ["Acrorad_0712-1001-1-07-02200.jpg,,,,,"
                  "Acrorad_0712-1001-1-07-02200x.jpg,,,,,"
                  "Acrorad_0712-1001-1-07-02200y.jpg,,,,,"
                  "Acrorad_0712-1001-1-07-02200xy.jpg,,,,,"];
for ind=1:length(lines)
    line = lines(ind);
    actual_solution = line{1};
    expected_solution = char(expected_lines(ind));
    verifyEqual(testCase,actual_solution,expected_solution)
end 
delete mirror_test_id_1hraeuru5eugete.csv
delete generated_id_adgaegeab.csv
end

function setup(~)
% generates csv file foe tests
file = fopen('mirror_test_id_14g3rb3rb7hffh8.csv', 'w');
fprintf(file, '%s,%i,%i,%i,%i,%s\n', 'Acrorad_0712-1001-1-07-02201.jpg', 749, 314, 774, 343, 'round_single');
file = fopen('mirror_test_id_1hraeuru5eugete.csv', 'w');
fprintf(file, 'Acrorad_0712-1001-1-07-02200.jpg,,,,,');
fclose('all');
end