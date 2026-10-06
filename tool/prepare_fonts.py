"""Derive portable static Nunito weights from the Google Fonts variable source.

Requires fonttools. Run from the project root after installing fonttools.
"""
from pathlib import Path
import sys

sys.path.insert(0, str(Path('.font-tools').resolve()))
from fontTools.ttLib import TTFont
from fontTools.varLib.instancer import instantiateVariableFont

root = Path(__file__).resolve().parents[1] / 'assets' / 'fonts'
for weight, name in [(400, 'Regular'), (700, 'Bold'), (800, 'ExtraBold'), (900, 'Black')]:
    source = TTFont(root / 'Nunito-Variable.ttf')
    instance = instantiateVariableFont(source, {'wght': weight}, inplace=False)
    instance.save(root / f'Nunito-{name}.ttf')
    print(f'Prepared Nunito {name} ({weight})')
