import runpy
import subprocess
import unittest
from pathlib import Path
from unittest.mock import patch


PROVIDER = runpy.run_path(str(Path(__file__).resolve().parents[1] / "codex"))


class StatuslineNameTests(unittest.TestCase):
    def parse(self, captured):
        result = subprocess.CompletedProcess([], 0, captured)
        with patch("subprocess.run", return_value=result):
            return PROVIDER["read_statusline_name"]("%3")

    def test_both_prompt_markers_with_empty_or_nonempty_input(self):
        for marker in ("›", "»"):
            for text in ("", " Ask Codex to do anything"):
                with self.subTest(marker=marker, text=text):
                    captured = (
                        f"{marker}{text}\n\n"
                        "  GPT-6-Astra ultra · 3b1b neural networks · ~/personal/Notes\n"
                    )
                    self.assertEqual(self.parse(captured), "3b1b neural networks")

    def test_current_prompt_does_not_reuse_an_older_statusline(self):
        captured = (
            "› old input\n\n"
            "  GPT-6-Astra ultra · old name · ~/personal/Notes\n\n"
            "» new input\n\n"
        )
        self.assertEqual(self.parse(captured), "")

    def test_multiline_input_keeps_the_footer_name(self):
        for marker in ("›", "»"):
            with self.subTest(marker=marker):
                captured = (
                    f"{marker} first paragraph\n\n"
                    "  example · input text · extra field\n"
                    "  continuation\n\n"
                    "  GPT-6-Astra ultra · current name · ~/personal/Notes\n"
                    "  ← for agents\n"
                )
                self.assertEqual(self.parse(captured), "current name")


if __name__ == "__main__":
    unittest.main()
