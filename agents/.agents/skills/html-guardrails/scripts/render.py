#!/usr/bin/env python3
"""Render a Markdown document as a self-contained HTML reading page."""

import argparse
import base64
import html
import mimetypes
from pathlib import Path
import re
from string import Template
import sys
from urllib.parse import unquote, urlsplit


ASSETS = Path(__file__).resolve().parent.parent / 'assets'


def prepare_mermaid(content):
    content, count = re.subn(
        r'<pre><code class="language-mermaid">(.*?)</code></pre>',
        r'<pre class="mermaid">\1</pre>', content, flags=re.DOTALL,
    )
    if not count:
        return content, ''
    runtime = (ASSETS / 'vendor/mermaid-tiny-12.2.0.min.js').read_text(encoding='utf-8')
    license_text = (ASSETS / 'vendor/mermaid-LICENSE.txt').read_text(encoding='utf-8')
    runtime = '/* Mermaid Tiny 12.2.0\n' + license_text + '\n*/\n' + runtime
    # The browser bundle is included only when the document uses Mermaid.
    runtime = re.sub(r'</script', r'<\\/script', runtime, flags=re.IGNORECASE)
    return content, runtime + '\n' + (ASSETS / 'mermaid.js').read_text(encoding='utf-8')


def embed_images(content, directory):
    def replace(match):
        source = html.unescape(match.group(2))
        if source.startswith('data:'):
            return match.group(0)
        url = urlsplit(source)
        if url.scheme or url.netloc:
            raise ValueError('Save the image locally before rendering: ' + source)
        path = directory / unquote(url.path)
        mime = mimetypes.guess_type(path.name)[0] or 'application/octet-stream'
        data = base64.b64encode(path.read_bytes()).decode('ascii')
        return match.group(1) + 'data:' + mime + ';base64,' + data + match.group(3)
    return re.sub(r'(<img\b[^>]*\bsrc=")([^"]*)(")', replace, content)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path, help='Markdown source file')
    parser.add_argument('-o', '--output', type=Path, required=True, help='HTML output file')
    parser.add_argument('--title', help='Browser title (default: first H1 or source filename)')
    parser.add_argument('--lang', default='zh-CN', help='Document language (default: zh-CN)')
    parser.add_argument('--css', type=Path, help='Additional CSS for this page')
    args = parser.parse_args()
    if args.source.resolve() == args.output.resolve():
        parser.error('Output must not overwrite the Markdown source')
    try:
        import markdown
    except ImportError:
        parser.error('Install the Markdown parser: python3 -m pip install Markdown')
    try:
        document = markdown.Markdown(
            extensions=['tables', 'fenced_code', 'attr_list', 'toc', 'md_in_html'],
            extension_configs={'toc': {'toc_depth': '2-3', 'permalink': False}},
        )
        body = document.convert(args.source.read_text(encoding='utf-8'))
        body = re.sub(r'(<table(?:\s[^>]*)?>.*?</table>)',
                      r'<div class="table-scroll" tabindex="0" role="region" aria-label="表格，可横向和纵向滚动">\1</div>',
                      body, flags=re.DOTALL)
        body, diagram_script = prepare_mermaid(body)
        heading = re.search(r'<h1\b[^>]*>(.*?)</h1>', body, re.DOTALL)
        title = args.title or (html.unescape(re.sub(r'<[^>]+>', '', heading.group(1)))
                               if heading else args.source.stem)
        body = embed_images(body, args.source.resolve().parent)
        css = (ASSETS / 'page.css').read_text(encoding='utf-8')
        if args.css:
            css += '\n' + args.css.read_text(encoding='utf-8')
        output = Template((ASSETS / 'page.html').read_text(encoding='utf-8')).substitute(
            title=html.escape(title), lang=html.escape(args.lang, quote=True),
            body=body, toc=document.toc if document.toc_tokens else '',
            css=css, js=(ASSETS / 'page.js').read_text(encoding='utf-8') + '\n' + diagram_script,
        )
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(output, encoding='utf-8')
        print(str(args.output))
        return 0
    except (OSError, ValueError) as error:
        print(str(error), file=sys.stderr)
        return 2


if __name__ == '__main__':
    sys.exit(main())
