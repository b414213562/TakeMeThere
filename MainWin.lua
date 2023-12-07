TakeMeThereWin = class(Turbine.UI.Window)
TakeMeThereWin.instance = nil;

function TakeMeThereWin.GetInstance()
    if (TakeMeThereWin.instance ~= nil) then
        return TakeMeThereWin.instance;
    end
    return TakeMeThereWin();
end

function TakeMeThereWin:Constructor()
    -- Enforce only one such window:
    if (TakeMeThereWin.instance) then
        return;
    end
    Turbine.UI.Window.Constructor(self);
    TakeMeThereWin.instance = self;
end

function TakeMeThereWin:DrawMainWin()
    self.borderWidth = 2;
    self.searchHeight = 25;
    self.searchBorder = 2;
    self.totalHeight = self.borderWidth * 2 + self.searchHeight + self.searchBorder * 2;
    self.searchWidth = 175;
    self.quickslotLeft = self.borderWidth * 2 + self.searchWidth + self.searchBorder * 2;
    self.totalWidth = self.borderWidth * 2 + self.searchWidth + self.searchBorder * 2 + 16 * 2 + 4;
    self.width = 300;
    self.height = 50;

    self:SetPosition(SETTINGS.MAINWIN.X, SETTINGS.MAINWIN.Y);
    self:SetVisible(SETTINGS.MAINWIN.VISIBLE);
    self:SetZOrder(0x7FFFFFFF); -- Most on-top we can get
    self:SetBackColor(Turbine.UI.Color(0.58, 0.58, 0.58));
    self:SetWantsKeyEvents(true);
    self:SetOpacity(.90);
    self:SetMouseVisible(true);
    self:SetSize(self.totalWidth, self.totalHeight);

    self.PositionChanged = function()
        SETTINGS.MAINWIN.X = self:GetLeft();
        SETTINGS.MAINWIN.Y = self:GetTop();
    end

    -- create simple border:
    self.border = Turbine.UI.Control();
    self.border:SetParent(self);
    self.border:SetBackColor(Turbine.UI.Color(6/255, 9/255, 17/255));
    self.border:SetMouseVisible(false);
    self.border:SetPosition(self.borderWidth, self.borderWidth);
    self.border:SetSize(self:GetWidth() - self.borderWidth * 2, self:GetHeight() - self.borderWidth * 2);

    -- Create close button:
    self.closeButton = Turbine.UI.Control();
    self.closeButton:SetParent(self);
    self.closeButton:SetBackground(_IMAGES.CLOSE_NORMAL);
    self.closeButton:SetSize(16, 16);
    self.closeButton:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.closeButton.MouseClick = function()
        self:Close();
        SETTINGS.MAINWIN.VISIBLE = false;
    end
    self.closeButton.MouseEnter = function()
        self.closeButton:SetBackground(_IMAGES.CLOSE_ROLLOVER);
    end
    self.closeButton.MouseDown = function()
        self.closeButton:SetBackground(_IMAGES.CLOSE_PRESSED);
    end
    self.closeButton.MouseUp = function()
        self.closeButton:SetBackground(_IMAGES.CLOSE_ROLLOVER);
    end
    self.closeButton.MouseLeave = function()
        self.closeButton:SetBackground(_IMAGES.CLOSE_NORMAL);
    end
    self.closeButton:SetZOrder(0x7FFFFFFF); -- Most on-top we can get 
    self.closeButton:SetPosition(self:GetWidth() - self.closeButton:GetWidth() - self.borderWidth, self.borderWidth);

    -- Create text box for coordinates:
    self.searchTextBox = Turbine.UI.Lotro.TextBox();
    self.searchTextBox:SetMouseVisible(false);
    self.searchTextBox:SetEnabled(false);
    self.searchTextBox:SetParent(self);
    self.searchTextBox:SetSize(175, 25);
    self.searchTextBox:SetPosition(self.borderWidth + 2, self.borderWidth + 2);
    self.searchTextBox:SetMultiline(false);
    self.searchTextBoxTimer = Timer(250, false, function() self:UpdateShortcut(self.searchTextBox:GetText()); end);
    self.searchTextBox.TextChanged = function(sender, args)
        self.searchTextBoxTimer:Start();
    end
    self.searchTextBox:SetZOrder(10);
    self.searchTextBox.MouseEnter = function(sender, args)
        self.searchTextBox:SetEnabled(true);
        self.searchTextBox:SetText("");
    end
    self.searchTextBox.MouseLeave = function(sender, args)
        self.searchTextBox:SetEnabled(false);
    end
    self.searchTextBox.FocusLost = function(sender, args)
        self.searchTextBox:SetEnabled(false);
    end

    self.searchTextBoxLabel = Turbine.UI.Label();
    self.searchTextBoxLabel:SetParent(self);
    self.searchTextBoxLabel:SetMouseVisible(false);
    self.searchTextBoxLabel:SetSize(self.searchTextBox:GetWidth(), self.searchTextBox:GetHeight());
    self.searchTextBoxLabel:SetPosition(self.searchTextBox:GetLeft(), self.searchTextBox:GetTop());
    self.searchTextBoxLabel:SetForeColor(Turbine.UI.Color.Gray);
    self.searchTextBoxLabel:SetFont(TrajanPro18);
    self.searchTextBoxLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    self.searchTextBoxLabel:SetText(GetString(_LANG.MAIN_WIN.SEARCH));
    self.searchTextBoxLabel:SetZOrder(1);

    -- Quickslot to trigger the Waypoint plugin:
    self.quickslotButton = Turbine.UI.Button();
    self.quickslotButton:SetParent(self);
    self.quickslotButton:SetSize(16,15);
    self.quickslotButton:SetPosition(self.quickslotLeft, self.borderWidth + 8);
    
    self.quickslot = Turbine.UI.Lotro.Quickslot();
    self.quickslot:SetParent(self.quickslotButton);
    self.quickslot:SetAllowDrop(false);
    
    self.quickslot.hider = Turbine.UI.Control();
    self.quickslot.hider:SetParent(self.quickslotButton);
    self.quickslot.hider:SetMouseVisible(false);
    self.quickslot.hider:SetBackground(_IMAGES.WAYPOINT_ARROW);
    self.quickslot.hider:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);

end

function TakeMeThereWin:UpdateShortcut(coords)
    local waypointCommand = "/way target " .. coords;
    self.quickslot:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, waypointCommand));
end

-- support moving the window:

function TakeMeThereWin:MouseDown(args)
    self:Activate();
    if (args.Button == Turbine.UI.MouseButton.Left) then
        local startLeft, startTop = self:GetPosition();
        local startX, startY = Turbine.UI.Display:GetMousePosition();
        self.mouseDown = { startX, startY };
        self.mouseDownOffset = { startX - startLeft, startY - startTop };
        self.hasMoved = false;
    end
end

function TakeMeThereWin:MouseMove(args)
    if (self.mouseDown) then
        local startX, startY = unpack(self.mouseDown);
        local currentX, currentY = Turbine.UI.Display.GetMousePosition();

        local deltaX = currentX - startX;
        local deltaY = currentY - startY;

        if (self.hasMoved or
            (math.abs(deltaX) > 5 or math.abs(deltaY) > 5)) then
            -- we've moved enough
            self.hasMoved = true;
            local offsetX, offsetY = unpack(self.mouseDownOffset);
            self:SetPosition(startX + deltaX - offsetX, startY + deltaY - offsetY);
        end
    end
end

function TakeMeThereWin:MouseUp(args)
    if (self.mouseDown) then
        if (self.hasMoved) then
            Onscreen(self);
        end
        self.mouseDown = nil;
    end
end

-- end moving window