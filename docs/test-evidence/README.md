# Test evidence

`Demo5-Test-Evidence.docx` embeds images rendered directly from captured command
output. These are transcript captures, not desktop terminal screenshots. TXT
files preserve original results; PNG files are retained separately as requested.
The verbose test record names every test and reports its actual outcome.

`create-test-evidence.py` uses the bundled Python runtime with python-docx and
Pillow. It reruns tests, lint and build, captures exit codes, and includes the
existing history-rehearsal log. Run the history rehearsal before regenerating.
Word/PDF exports under rendered are layout QA intermediates and are not versioned.
