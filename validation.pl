my @tests=("bd","first","test","test2","test3","test4","test5","test6","test7","test8","test9","test9.2","test9.3","test10","test11","test12","test13","test14","test15","test16","test17","test18","test19");
foreach my $test (@tests)
{
	`bin/json_to_sql < exemple/$test.json > exemple/$test.attendu.sql`
}