use Lingua::JA::Romanize::Japanese;

my $conv = Lingua::JA::Romanize::Japanese->new();
my $roman = $conv->char( $kanji );
printf( "<ruby><rb>%s</rb><rt>%s</rt></ruby>", $kanji, $roman );

my @array = $conv->string( $string );
foreach my $pair ( @array ) {
	my( $raw, $ruby ) = @$pair;
	if ( defined $ruby ) {
		printf( "<ruby><rb>%s</rb><rt>%s</rt></ruby>", $raw, $ruby );
	} 
	else {
		print $raw;
	}
}