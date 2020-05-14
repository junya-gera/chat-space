require 'rails_helper'

# フィーチャースペックでの言葉の違い
  # it: scenario, before: background, describe: feature, let: given

feature 'message', type: :feature do
  let{:user}{create(:user)}

end