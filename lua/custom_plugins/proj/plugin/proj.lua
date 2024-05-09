local M = {}

local projlist_folder = vim.fn.stdpath("data") .. "/proj"

-- Should we JSON ? :/
local projlist_file = projlist_folder .. "/projlist.json"

local function fs_dir_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat ~= nil and stat.type == "directory"
end

local function fs_file_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat ~= nil and stat.type == "file"
end

local function fs_read_file(path)
  local stat = vim.loop.fs_stat(path)

  if not stat or stat.type ~= "file" then
    return nil
  end

  local handle = vim.loop.fs_open(path, "r", 438)

  if not handle then
    return nil
  end

  local data = vim.loop.fs_read(handle, stat.size, 0)

  if type(data) ~= "string" then
    return nil
  end

  return data
end

local function json_decode_safe(expr)
  local success, result = pcall(vim.fn.json_decode, expr)

  if success then
    return result
  else
    return nil
  end
end

function M.setup()
  if not fs_dir_exists(projlist_folder) then
    vim.notify("Creating Project List since it doesn't exist", vim.log.levels.INFO)
    vim.loop.fs_mkdir(projlist_folder, 448)

    -- Assuming the file also doesn't exist, just write it with empty object
    local handle = vim.loop.fs_open(projlist_file, "w", 483)

    if not handle then
      vim.notify("Couldn't create project list file", vim.log.levels.ERROR)
      return
    end

    vim.loop.fs_write(handle, "{}", -1)
    vim.loop.fs_close(handle)

    return
  end

  if not fs_file_exists(projlist_file) then
    vim.notify("Project file doesn't exist", vim.log.levels.ERROR)
    local handle = vim.loop.fs_open(projlist_file, "w", 483)

    if not handle then
      vim.notify("Couldn't create project list file", vim.log.levels.ERROR)
      return {}
    end

    vim.loop.fs_write(handle, "{}", -1)
    vim.loop.fs_close(handle)

    return {}
  end

end

function M.get_project_list()
  local contents = fs_read_file(projlist_file)

  if not contents then
    vim.notify("Couldn't read project file", vim.log.levels.ERROR)
    return {}
  end

  local decoded = json_decode_safe(contents)

  if not decoded or type(decoded) ~= "table" then
    vim.notify("Couldn't read project file", vim.log.levels.ERROR)
    return {}
  end

  return decoded
end

local function table_find_key(tbl, f)
  for k, v in pairs(tbl) do
    if f(v, k) then
      return k
    end
  end

  return nil
end

function M.delete_entry_at_index(i)
  local contents = M.get_project_list()

  if i < 1 or i > #contents then
    vim.notify("Invalid index", vim.log.levels.ERROR)
    return false
  end

  table.remove(contents, i)

  local handle = vim.loop.fs_open(projlist_file, "w", 483)

  if not handle then
    vim.notify("Couldn't open project list file", vim.log.levels.ERROR)
    return false
  end

  vim.loop.fs_write(handle, vim.fn.json_encode(contents), -1)

  vim.loop.fs_close(handle)

  return true
end

local function string_trim(s)
  return s:match"^%s*(.*)":match"(.-)%s*$"
end

function M.prompt_open()
  local projlist = M.get_project_list()

  local fzf = require("fzf-lua")

  local contents = function (fzf_cb)
    for i=1,#projlist do
      fzf_cb(projlist[i].label .. "\t" .. fzf.utils.ansi_codes.grey(projlist[i].path))
    end
    fzf_cb()
  end

  fzf.fzf_exec(
    contents, {
      prompt = "Project > ",
      actions = {
        ["default"] = {
          function (selected)
            selected[1] = string.gsub(selected[1], "\t.*$", "")

            local index = table_find_key(projlist, function (v)
              return v.label == selected[1]
            end)

            if index == nil then
              vim.notify("project index not found", vim.log.levels.ERROR)

              return
            end

            local path = projlist[index].path

            vim.api.nvim_set_current_dir(path)

            vim.notify("Moved to project: " .. selected[1], vim.log.levels.INFO)
            vim.api.nvim_win_close(0, true)
          end
        },
        ["ctrl-x"] = {
          function (selected)
            local index = table_find_key(
              projlist,
              function (v)
                return string_trim(v.label) == string_trim(selected[1])
              end
            )

            if not index then
              vim.notify("delete index not found", vim.log.levels.ERROR)
              return
            end

            local delete_success = M.delete_entry_at_index(index)

            if not delete_success then
              vim.notify("Failed deleting entry: " .. selected[1], vim.log.levels.ERROR)
              return
            end

            table.remove(projlist, index)

            vim.notify("Project entry deleted: " .. selected[1], vim.log.levels.INFO)
          end,
          fzf.actions.resume
        }
      },
      fzf_opts = {
        ["--header"] = vim.fn.shellescape(
          (":: %s to remove a project from the list"):format(fzf.utils.ansi_codes.yellow("<Ctrl-x>"))
        )
      }
    }
  )
end

function M.prompt_add()
  local cwd = vim.fn.getcwd()
  local dir_name = cwd:match("([^/]+)/?$")

  vim.ui.input(
    {
      prompt = "Label: ",
      default = dir_name,
    },
    function (input)
      if not input then
        return
      end

      local label = string_trim(input)

      if #label == 0 then
        vim.notify("Label cannot be empty", vim.log.levels.ERROR)
        return
      end

      local project_list = M.get_project_list()

      if not project_list then
        vim.notify("Couldn't read project list", vim.log.levels.ERROR)
        return
      end

      local similar_key = table_find_key(
        project_list,
        function (proj)
          return proj.label == label
        end
      )

      if similar_key then
        vim.notify("Similar Label exists. Use another name", vim.log.levels.ERROR)
        return
      end

      vim.ui.input(
        {
          prompt = "Path: ",
          default = cwd
        },
        function (path_input)
          local path = path_input

          if not path then
            return
          end

          M.add_to_project_list(label, path)
        end
      )
    end
  )
end

function M.add_to_project_list(label, path)
  local contents = fs_read_file(projlist_file)

  if not contents then
    vim.notify("Couldn't read project file", vim.log.levels.ERROR)
    return
  end

  local decoded = json_decode_safe(contents)

  if not decoded or type(decoded) ~= "table" then
    vim.notify("Couldn't read project file", vim.log.levels.ERROR)
    return
  end

  decoded[#decoded+1] = { label = label, path = path }

  local handle = vim.loop.fs_open(projlist_file, "w", 483)

  if not handle then
    vim.notify("Couldn't open project list file", vim.log.levels.ERROR)
    return
  end

  vim.loop.fs_write(handle, vim.fn.json_encode(decoded), -1)

  vim.loop.fs_close(handle)

  vim.notify("Added project to list", vim.log.levels.INFO)
end

return M
