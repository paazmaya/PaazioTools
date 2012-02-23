/* http://twitcode.org/zc */
(function () {
    try {
        if (!google.doodle) google.doodle = {};
        var a = 200,
            g = -200,
            j = -200,
            k, l, m, n = 0,
            o = 0,
            p = 0,
            q = 35,
            r, s = [],
            t, u, v;
        google.doodle.init = function () {
            if (!v && window.location.href.indexOf("#") == -1) {
                v = true;
                if (t = document.getElementById("hplogo")) {
                    google.j && google.j.en && w(100, x, function () {
                        return google.rein && google.dstr
                    });
                    w(100, y, function () {
                        return google.listen
                    });
                    w(100, z, function () {
                        return google.browser
                    })
                }
            }
        };
        var w = function (b, c, d) {
            if (d()) c();
            else b < 200 && window.setTimeout(function () {
                w(b + 1, c, d)
            }, b)
        },
            x = function () {
                if (!google.doodle.n) {
                    google.doodle.n = true;
                    google.rein.push(google.doodle.init);
                    google.dstr.push(A)
                }
            },
            y = function () {
                google.listen(document, "mousemove", B)
            },
            B = function (b) {
                a = 200;
                g = b.clientX - t.offsetLeft;
                j = b.clientY - t.offsetTop
            },
            C = function () {
                return [u ? window.screenLeft : window.screenX, u ? window.screenTop : window.screenY, document.body.clientWidth]
            },
            z = function () {
                u = google.browser.engine.IE && google.browser.engine.version != "9.0";
                s = [D(202, 78, 9, "ed9d33"), D(348, 83, 9, "d44d61"), D(256, 69, 9, "4f7af2"), D(214, 59, 9, "ef9a1e"), D(265, 36, 9, "4976f3"), D(300, 78, 9, "269230"), D(294, 59, 9, "1f9e2c"), D(45, 88, 9, "1c48dd"), D(268, 52, 9, "2a56ea"), D(73, 83, 9, "3355d8"), D(294, 6, 9, "36b641"), D(235, 62, 9, "2e5def"), D(353, 42, 8, "d53747"), D(336, 52, 8, "eb676f"), D(208, 41, 8, "f9b125"), D(321, 70, 8, "de3646"), D(8, 60, 8, "2a59f0"), D(180, 81, 8, "eb9c31"), D(146, 65, 8, "c41731"), D(145, 49, 8, "d82038"), D(246, 34, 8, "5f8af8"), D(169, 69, 8, "efa11e"), D(273, 99, 8, "2e55e2"), D(248, 120, 8, "4167e4"), D(294, 41, 8, "0b991a"), D(267, 114, 8, "4869e3"), D(78, 67, 8, "3059e3"), D(294, 23, 8, "10a11d"), D(117, 83, 8, "cf4055"), D(137, 80, 8, "cd4359"), D(14, 71, 8, "2855ea"), D(331, 80, 8, "ca273c"), D(25, 82, 8, "2650e1"), D(233, 46, 8, "4a7bf9"), D(73, 13, 8, "3d65e7"), D(327, 35, 6, "f47875"), D(319, 46, 6, "f36764"), D(256, 81, 6, "1d4eeb"), D(244, 88, 6, "698bf1"), D(194, 32, 6, "fac652"), D(97, 56, 6, "ee5257"), D(105, 75, 6, "cf2a3f"), D(42, 4, 6, "5681f5"), D(10, 27, 6, "4577f6"), D(166, 55, 6, "f7b326"), D(266, 88, 6, "2b58e8"), D(178, 34, 6, "facb5e"), D(100, 65, 6, "e02e3d"), D(343, 32, 6, "f16d6f"), D(59, 5, 6, "507bf2"), D(27, 9, 6, "5683f7"), D(233, 116, 6, "3158e2"), D(123, 32, 6, "f0696c"), D(6, 38, 6, "3769f6"), D(63, 62, 6, "6084ef"), D(6, 49, 6, "2a5cf4"), D(108, 36, 6, "f4716e"), D(169, 43, 6, "f8c247"), D(137, 37, 6, "e74653"), D(318, 58, 6, "ec4147"), D(226, 100, 5, "4876f1"), D(101, 46, 5, "ef5c5c"), D(226, 108, 5, "2552ea"), D(17, 17, 5, "4779f7"), D(232, 93, 5, "4b78f1")];
                var b = C();
                k = b[0];
                l = b[1];
                m = b[2];
                E()
            },
            A = function () {
                google.unlisten(document, "mousemove", B);
                r && window.clearTimeout(r);
                if (s) for (var b = 0, c; c = s[b++];) c.m()
            },
            E = function () {
                var b = C(),
                    c = b[0],
                    d = b[1];
                b = b[2];
                n = c - k;
                o = d - l;
                p = b - m;
                k = c;
                l = d;
                m = b;
                a = Math.max(0, a - 2);
                c = true;
                for (d = 0; b = s[d++];) {
                    b.update();
                    if (c) c = b.i
                }
                q = c ? 250 : 35;
                r = window.setTimeout(E, q)
            },
            D = function (b, c, d, h) {
                return new F(b, c, d, h)
            },
            F = function (b, c, d, h) {
                this.x = this.o = b;
                this.y = this.p = c;
                this.k = this.h = d;
                b = 100;
                this.a = b * (Math.random() - 0.5);
                this.c = b * (Math.random() - 0.5);
                this.l = 3 + Math.random() * 98;
                this.r = 0.1 + Math.random() * 0.4;
                this.e = 0;
                this.g = 1;
                this.i = false;
                this.d = document.createElement("div");
                this.d.className = "particle";
                this.style = this.d.style;
                h = "#" + h;
                if (u) {
                    this.d.innerHTML = ".";
                    this.style.fontFamily = "Monospace";
                    this.style.color = h;
                    this.style.fontSize = "100px";
                    this.style.lineHeight = 0;
                    this.style.cursor = "default"
                } else {
                    this.d.className += " circle";
                    this.style.backgroundColor = h
                }
                t.appendChild(this.d);
                this.m = function () {
                    t.removeChild(this.d)
                };
                this.update = function () {
                    this.x += this.a;
                    this.y += this.c;
                    this.a = Math.min(50, Math.max(-50, (this.a + (n + p) / this.h) * 0.92));
                    this.c = Math.min(50, Math.max(-50, (this.c + o / this.h) * 0.92));
                    var e = g - this.x,
                        f = j - this.y,
                        i = Math.sqrt(e * e + f * f);
                    e /= i;
                    f /= i;
                    if (i < a) {
                        this.a -= e * this.l;
                        this.c -= f * this.l;
                        this.e += (0.005 - this.e) * 0.4;
                        this.g = Math.max(0, this.g * 0.9 - 0.01);
                        this.a *= 1 - this.g;
                        this.c *= 1 - this.g
                    } else {
                        this.e += (this.r - this.e) * 0.005;
                        this.g = Math.min(1, this.g + 0.03)
                    }
                    e = this.o - this.x;
                    f = this.p - this.y;
                    i = Math.sqrt(e * e + f * f);
                    this.a += e * this.e;
                    this.c += f * this.e;
                    this.k = this.h + i / 8;
                    this.i = i < 0.3 && this.a < 0.3 && this.c < 0.3;
                    if (!this.i) {
                        if (!u) this.style.width = this.style.height = this.k * 2 + "px";
                        this.style.left = this.x - (u ? 20 : 0) + "px";
                        this.style.top = this.y + "px"
                    }
                }
            }
    } catch (G) {
        google.ml(G, false, {
            _sn: "PAR"
        })
    };
})();
google.doodle.init()