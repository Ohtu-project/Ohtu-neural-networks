%% Main function to generate tests
function tests = labeling_tool_test
    tests = functiontests(localfunctions);
end

%% Test functions
function test_is_even_empty(testCase)
    global map;
    m = [];
    f = map('is_even');
    actSolution = f(m);
    expSolution = true;
    verifyEqual(testCase, actSolution, expSolution)
end

function test_is_even_even(testCase)
    global map;
    m = [1; 2];
    f = map('is_even');
    actSolution = f(m);
    expSolution = true;
    verifyEqual(testCase, actSolution, expSolution)
end

function test_is_even_not_even(testCase)
    global map;
    m = [1; 2; 3];
    f = map('is_even');
    actSolution = f(m);
    expSolution = false;
    verifyEqual(testCase, actSolution, expSolution)
end

function test_length_of_empty(testCase)
    global map;
    m = [];
    f = map('length_of');
    actSolution = f(m);
    expSolution = 0;
    verifyEqual(testCase, actSolution, expSolution)
end

function test_length_of_not_empty(testCase)
    global map;
    m = [1 2 3 4; 5 6 7 8];
    f = map('length_of');
    actSolution = f(m);
    expSolution = 2;
    verifyEqual(testCase, actSolution, expSolution)
end

function test_remove_last_item_empty(testCase)
    global map;
    m = [];
    f = map('remove_last_item');
    actSolution = f(m);
    expSolution = [];
    verifyEqual(testCase, actSolution, expSolution)
end

function test_remove_last_item_numbers(testCase)
    global map;
    m = [1;2;3];
    f = map('remove_last_item');
    actSolution = f(m);
    expSolution = [1;2];
    verifyEqual(testCase, actSolution, expSolution)
end

function test_remove_last_item_vectors(testCase)
    global map;
    m = [[1,2,3];[4,5,6];[7,8,9]];
    f = map('remove_last_item');
    actSolution = f(m)
    expSolution = [[1,2,3];[4,5,6]];
    verifyEqual(testCase, actSolution, expSolution)
end

function test_rearrange_points(testCase)
    global map
    point1 = [1, 1];
    point2 = [2, 2];
    point3 = [2, 1];
    point4 = [1, 2];
    points = [point1; point2; point2; point1; point3; point4; point4; point3; point1; point2; point2; point1; point3; point4; point4; point3];
    f = map('rearrange_points');
    actSolution = f(points);
    expSolution = [point1; point2; point1; point2; point1; point2; point1; point2; point1; point2; point1; point2; point1; point2; point1; point2];
    verifyEqual(testCase, actSolution, expSolution)
end

function test_put_class_round_when_empty(testCase)
    global map
    classes = ["", ""];
    f = map('put_class');
    actSolution = f("round", classes);
    expSolution = ["round", ""];
    verifyEqual(testCase, actSolution, expSolution)
end

function test_put_class_single_when_empty(testCase)
    global map
    classes = ["", ""];
    f = map('put_class');
    actSolution = f("single", classes);
    expSolution = ["", "single"];
    verifyEqual(testCase, actSolution, expSolution)
end

function test_put_class_double_when_empty(testCase)
    global map
    classes = ["", ""];
    f = map('put_class');
    actSolution = f("double", classes);
    expSolution = ["", "double"];
    verifyEqual(testCase, actSolution, expSolution)
end

function test_put_class_trigonal_when_trigonal(testCase)
    global map
    classes = ["trigonal", ""];
    f = map('put_class');
    actSolution = f("trigonal", classes);
    expSolution = ["", ""];
    verifyEqual(testCase, actSolution, expSolution)
end

function test_put_class_trigonal_when_round(testCase)
    global map
    classes = ["round", ""];
    f = map('put_class');
    actSolution = f("trigonal", classes);
    expSolution = ["trigonal", ""];
    verifyEqual(testCase, actSolution, expSolution)
end

function test_put_class_single_when_double(testCase)
    global map
    classes = ["", "double"];
    f = map('put_class');
    actSolution = f("single", classes);
    expSolution = ["", "single"];
    verifyEqual(testCase, actSolution, expSolution)
end

function test_put_class_trigonal_when_round_double(testCase)
    global map
    classes = ["round", "double"];
    f = map('put_class');
    actSolution = f("trigonal", classes);
    expSolution = ["trigonal", "double"];
    verifyEqual(testCase, actSolution, expSolution)
end

function test_class_given_empty(testCase)
    global map
    classes = [];
    f = map('class_given');
    actSolution = f(classes);
    expSolution = false;
    verifyEqual(testCase, actSolution, expSolution)
end

function test_class_given_round(testCase)
    global map
    classes = ["round", ""];
    f = map('class_given');
    actSolution = f(classes);
    expSolution = false;
    verifyEqual(testCase, actSolution, expSolution)
end

function test_class_given_single(testCase)
    global map
    classes = ["", "single"];
    f = map('class_given');
    actSolution = f(classes);
    expSolution = false;
    verifyEqual(testCase, actSolution, expSolution)
end

function test_class_given_trigonal_double(testCase)
    global map
    classes = ["trigonal", "double"];
    f = map('class_given');
    actSolution = f(classes);
    expSolution = true;
    verifyEqual(testCase, actSolution, expSolution)
end

function setup(testCase)
    global map
    map = labeling_tool;
end