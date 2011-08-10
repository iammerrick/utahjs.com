var codez = [].slice.call(document.getElementsByTagName('code'), 0);
for (var i = 0, l = codez.length, language; i < l; i++) {
  language = codez[i].getAttribute('data-language');
  if (language) hilite(codez[i]);
}
