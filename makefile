all: clean build
clean:
	fpm clean
pretty:
	fprettify --indent 2 --exclude build --exclude .git --recursive .
run: pretty
	fpm run \
		--flag "-fno-range-check" \
		--flag "-fbounds-check" \
		--flag "-L/opt/homebrew/Cellar/raylib/5.5/lib/" \
		--flag "-L/opt/homebrew/Cellar/glfw/3.4/lib/" \
		--flag "-L/opt/homebrew/Cellar/mesa/24.2.8/lib/"
