my @tests=("bd","first","test","test2","test3","test4","test5","test6","test7","test8","test9","test9.2","test9.3","test10","test11","test12","test13","test14","test15","test16","test17","test18","test19");
$b=1;
foreach my $test (@tests)
{
	my $e=`bin/json_to_sql < exemple/$test.json > temp/$test.test.sql && diff temp/$test.test.sql exemple/$test.attendu.sql`;
	if($e ne "") {print "$test\n";$b=0;}
}
if($b) { print "test OK\n"; }