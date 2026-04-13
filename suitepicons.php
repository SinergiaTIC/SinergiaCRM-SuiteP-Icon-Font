<?php
/**
 * This file is part of SinergiaCRM.
 * SinergiaCRM is a work developed by SinergiaTIC Association, based on SuiteCRM.
 * Copyright (C) 2013 - 2026 SinergiaTIC Association
 */

// 1. Configuration
$scssFile = 'suitepicon/suitepicon-glyphs.scss';
$outputFile = 'suitepicons.html';

if (!file_exists($scssFile)) {
    die("Error: SCSS file not found at $scssFile.\n");
}

// 2. Parse the SCSS
$scssContent = file_get_contents($scssFile);
preg_match_all('/\.(suitepicon-[\w-]+):before\s*{\s*content:\s*"\\\\([\w]+)";\s*}/', $scssContent, $matches);

$icons = [];
if (!empty($matches[1])) {
    foreach ($matches[1] as $index => $className) {
        $icons[] = [
            'class'   => $className,
            'unicode' => $matches[2][$index],
            'short'   => str_replace('suitepicon-', '', $className)
        ];
    }
}

$totalIcons = count($icons);

// 3. Generate HTML
$html = <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SinergiaCRM Suitepicons Gallery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --icon-size: 36px;
            --icon-color: #555;
            --preview-bg: #ffffff;
        }

        @font-face {
            font-family: 'SuiteP_Internal';
            src: url('suitepicon/suitepicon.woff') format('woff'),
                 url('suitepicon/suitepicon.ttf') format('truetype');
        }

        body { background-color: #f4f6f9; padding: 40px 20px; font-family: sans-serif; }
        
        .my-icon {
            font-family: 'SuiteP_Internal' !important;
            font-size: var(--icon-size);
            color: var(--icon-color);
            
            /* SOLUCIÓ: Forçar estil normal per evitar l'efecte estirat */
            font-style: normal !important;
            font-weight: normal !important;
            font-variant: normal !important;
            text-transform: none !important;
            
            line-height: 1;
            display: inline-block;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

HTML;

foreach ($icons as $icon) {
    $html .= "        .{$icon['class']}:before { content: \"\\{$icon['unicode']}\"; }\n";
}

$html .= <<<HTML
        
        .search-container { max-width: 500px; margin: 0 auto 30px; }

        /* Circular Color Pickers */
        .config-color-input {
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            width: 35px !important;
            height: 35px !important;
            background: none;
            border: 2px solid #ddd !important;
            border-radius: 50% !important;
            padding: 0 !important;
            cursor: pointer;
            overflow: hidden;
        }
        .config-color-input::-webkit-color-swatch-wrapper { padding: 0; }
        .config-color-input::-webkit-color-swatch { border: none; border-radius: 50%; }

        /* Card split: Preview vs Info */
        .icon-card {
            background: white;
            border: 1px solid rgba(0,0,0,0.1);
            border-radius: 12px;
            overflow: hidden;
            transition: transform 0.2s;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .icon-card:hover { transform: translateY(-5px); box-shadow: 0 8px 15px rgba(0,0,0,0.1); }
        
        .icon-preview {
            background-color: var(--preview-bg);
            padding: 25px 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-grow: 1;
            transition: background-color 0.2s;
        }
        
        .icon-info {
            background: #f8f9fa;
            border-top: 1px solid #eee;
            padding: 10px;
            text-align: center;
        }

        .icon-name {
            font-size: 10px;
            font-family: monospace;
            color: #666;
            word-break: break-all;
        }

        #toast {
            visibility: hidden; background: #333; color: white; padding: 12px 25px;
            position: fixed; bottom: 30px; left: 50%; transform: translateX(-50%);
            border-radius: 50px; z-index: 1000; opacity: 0; transition: 0.3s;
        }
        #toast.show { visibility: visible; opacity: 1; bottom: 40px; }
    </style>
</head>
<body>

<div class="container">
    <div class="text-center mb-4">
        <h1 class="fw-bold">🎨 Suitepicons</h1>
        <p class="text-muted">Total: $totalIcons icons</p>
    </div>

    <div class="card shadow-sm mb-4 border-0 rounded-4">
        <div class="card-body d-flex flex-wrap align-items-center gap-4 justify-content-center">
            <div class="d-flex align-items-center gap-2">
                <label class="small fw-bold">Size:</label>
                <input type="range" id="sizeRange" min="16" max="64" value="36" class="form-range" style="width: 100px;">
                <span id="sizeValue" class="badge bg-primary">36px</span>
            </div>
            <div class="d-flex align-items-center gap-2">
                <label class="small fw-bold">Icon:</label>
                <input type="color" id="colorPicker" value="#555555" class="config-color-input">
            </div>
            <div class="d-flex align-items-center gap-2">
                <label class="small fw-bold">BG:</label>
                <input type="color" id="bgPicker" value="#ffffff" class="config-color-input">
            </div>
            <button class="btn btn-sm btn-outline-secondary rounded-pill px-3" onclick="resetConfig()">Reset</button>
        </div>
    </div>

    <div class="search-container">
        <input type="text" id="search" class="form-control form-control-lg shadow-sm rounded-pill" placeholder="🔍 Search...">
    </div>

    <div class="row g-3" id="icon-grid">
HTML;

foreach ($icons as $icon) {
    $searchData = strtolower($icon['class'] . ' ' . $icon['short']);
    $html .= <<<HTML
        <div class="col-6 col-sm-4 col-md-3 col-lg-2 icon-item" data-search="{$searchData}">
            <div class="icon-card" onclick="copyToClipboard('{$icon['class']}')">
                <div class="icon-preview">
                    <i class="my-icon {$icon['class']}"></i>
                </div>
                <div class="icon-info">
                    <div class="icon-name">{$icon['short']}</div>
                </div>
            </div>
        </div>
HTML;
}

$html .= <<<HTML
    </div>
</div>

<div id="toast">Copied!</div>

<script>
    const root = document.querySelector(':root');
    const sRange = document.getElementById('sizeRange');
    const cPicker = document.getElementById('colorPicker');
    const bPicker = document.getElementById('bgPicker');

    function updateView() {
        root.style.setProperty('--icon-size', sRange.value + 'px');
        document.getElementById('sizeValue').innerText = sRange.value + 'px';
        root.style.setProperty('--icon-color', cPicker.value);
        root.style.setProperty('--preview-bg', bPicker.value);
    }

    function resetConfig() {
        sRange.value = 36;
        cPicker.value = '#555555';
        bPicker.value = '#ffffff';
        updateView();
    }

    [sRange, cPicker, bPicker].forEach(el => el.addEventListener('input', updateView));

    document.getElementById('search').addEventListener('input', (e) => {
        const term = e.target.value.toLowerCase();
        document.querySelectorAll('.icon-item').forEach(item => {
            item.style.display = item.getAttribute('data-search').includes(term) ? '' : 'none';
        });
    });

    function copyToClipboard(cls) {
        navigator.clipboard.writeText('<span class="suitepicon ' + cls + '"></span>').then(() => {
            const t = document.getElementById("toast");
            t.classList.add("show");
            setTimeout(() => t.classList.remove("show"), 2000);
        });
    }
</script>
</body>
</html>
HTML;

file_put_contents($outputFile, $html);
echo "Success: $outputFile generated.\n";