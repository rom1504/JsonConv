if((scalar @ARGV)!=1)
{
	print("usage: $0 <fichier.sql>");
	exit(1);
}
open(my $f,"<".$ARGV[0]);
my $contenu=join('',<$f>);
close($f);
$contenu =~ s/\'/''/g;
$contenu =~ s/\\"/sdiodddçdçffddsççds/g;
$contenu =~ s/\"/'/g;
$contenu =~ s/sdiodddçdçffddsççds/"/g;
$contenu="begin;\n".$contenu."\ncommit;\n";
print($contenu);