local M = {}

local function get_pnpm_scripts()
    local scripts = {}
    local package_json = vim.fn.findfile('package.json', '.;')
    if package_json == '' then
        return scripts
    end
    local file = io.open(package_json, 'r')
    if not file then
        return scripts
    end
    local content = file:read '*a'
    file:close()
    local ok, json = pcall(vim.fn.json_decode, content)
    if not ok or not json or not json.scripts then
        return scripts
    end
    for name, _ in pairs(json.scripts) do
        table.insert(scripts, name)
    end
    table.sort(scripts)
    return scripts
end

function M.pnpm_run(script)
    if not script or script == '' then
        vim.notify('No script specified', vim.log.levels.ERROR)
        return
    end
    vim.cmd('split | terminal pnpm run ' .. script)
end

vim.api.nvim_create_user_command('PnpmRun', function(opts)
    M.pnpm_run(opts.args)
end, {
    nargs = 1,
    complete = function()
        return get_pnpm_scripts()
    end,
})

-- Telescope integration
local has_telescope, pickers = pcall(require, 'telescope.pickers')
if has_telescope then
    local finders = require 'telescope.finders'
    local conf = require('telescope.config').values
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'

    function M.pnpm_scripts_picker(opts)
        opts = opts or {}
        local scripts = get_pnpm_scripts()
        pickers
            .new(opts, {
                prompt_title = 'pnpm scripts',
                finder = finders.new_table { results = scripts },
                sorter = conf.generic_sorter(opts),
                attach_mappings = function(prompt_bufnr, map)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        M.pnpm_run(selection[1])
                    end)
                    return true
                end,
            })
            :find()
    end

    vim.api.nvim_create_user_command('PnpmScripts', function()
        M.pnpm_scripts_picker()
    end, {})
end

return M
