module Jshelpers
    def bypass_confirm_dialog
        page.evaluate_script('window.confirm = function() {retrun true;}')
    end
end 