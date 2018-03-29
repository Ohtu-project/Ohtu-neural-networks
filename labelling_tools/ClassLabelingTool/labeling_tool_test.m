%% Main function to generate tests
function tests = labeling_tool_test
    tests = functiontests(localfunctions);
end

%% Test functions
function test_length_empty(testCase)
    m = [];
    map = labeling_tool;
    f = map('length_of');
    actSolution = f(m);
    expSolution = 0;
    verifyEqual(testCase, actSolution, expSolution)
end

function test_rearrange_points(testCase)
    point1 = [1, 1];
    point2 = [2, 2];
    point3 = [2, 1];
    point4 = [1, 2];
    points = [point1; point2; point2; point1; point3; point4; point4; point3; point1; point2; point2; point1; point3; point4; point4; point3];
    map = labeling_tool;
    f = map('rearrange_points');
    actSolution = f(points);
    expSolution = [point1; point2; point1; point2; point1; point2; point1; point2; point1; point2; point1; point2; point1; point2; point1; point2];
    verifyEqual(testCase, actSolution, expSolution)
end