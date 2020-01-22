// Copyright 2020 Danilo Spinella <danyspin97@protonmail.com>
// Distributed under the terms of the GNU General Public License v2

module libtt.parser.longrun_director;

import libtt.parser.environment_builder : EnvironmentBuilder;
import libtt.parser.logger_script_builder : LoggerScriptBuilder;
import libtt.parser.longrun_options_builder : LongrunOptionsBuilder;
import libtt.parser.main_section_builder : MainSectionBuilder;
import libtt.parser.main_section : MainSection;
import libtt.parser.script_builder : ScriptBuilder;
import libtt.parser.section_builder : SectionBuilder;
import libtt.parser.service_director : ServiceDirector;
import libtt.services.environment : Environment;
import libtt.services.logger_script : LoggerScript;
import libtt.services.longrun: Longrun;
import libtt.services.longrun_options : LongrunOptions;
import libtt.services.script : Script;
import libtt.services.service : Service;

class LongrunDirector : ServiceDirector
{
public:
    override Service instanceService(string path)
    {
        auto service = new Longrun(
            mainSection.name,
            mainSection.polishName,
            mainSection.description,
            mainSection.path,
            options,
            run,
        );

        if (finish !is null)
        {
            service.finish = finish;
        }
        if (logger !is null)
        {
            service.logger = logger;
        }

        return service;
    }

    override SectionBuilder getBuilderForSection(string section)
    {
        switch (section)
        {
            case "main":
                return new MainSectionBuilder(mainSection);
            case "run":
                return new ScriptBuilder(run);
            case "finish":
                return new ScriptBuilder(finish);
            case "logger":
                return new LoggerScriptBuilder(logger);
            case "config":
                return new EnvironmentBuilder(environment);
            case "options":
                return new LongrunOptionsBuilder(options);
            default:
                auto msg = `Section "` ~ section ~ `" is not supported.`;
                throw new Exception(msg);
        }
    }

private:
    Environment environment;
    MainSection mainSection;
    Script run;
    Script finish;
    LoggerScript logger;
    LongrunOptions options;
}
